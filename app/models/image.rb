class Image < ActiveRecord::Base
  
  belongs_to :build, :touch => true

  before_create :put
  
  # for holding a file that's about to be uploaded (this isn't actually saved to the DB)
  attr_accessor :file
  
  OUTPUT_FORMAT = 'jpg'
  META = { :small     => { :prefix => 's_', :size => "250x250>"   },
           :large     => { :prefix => 'l_', :size => "1024x1024>" },
           :original  => { :prefix => 'o_', :save_dimensions => true } }
  
  
  # prefix to the path for this image (not including filename)
  def full_path_prefix
    self.build.site.path + '/' + self.build.path
  end

  
  # the full URL
  def url(size=:small)
    AWS_CONFIG[:s3][:cdn] + '/' + self.full_path_prefix + '/' + META[size][:prefix] + self.filename
  end
  
  
  def put
    if self.file
      Rails.logger.debug "New image, saving..."
      remote_filename = UUID.new.generate + '.' + OUTPUT_FORMAT # filename becomes the timestamp to avoid name conflicts
      META.each do |size,options|
        tempfile = Tempfile.new(['watchmemake','.jpg'])
        tempfile << File.read(self.file.tempfile)
        self.width, self.height = get_size(tempfile) if options[:save_dimensions]
        resize(tempfile, options) if options[:size]
        upload(tempfile, options[:prefix]+remote_filename)
      end
      self.filename = remote_filename
    else
      raise 'No file attached to image'
    end
  end
  
  
  # Creates and uploads a single image (the model should know everything it needs to about an image, including how to save itself wherever)
  # Returns the name of the file it just uploaded (or throws an error if something goes wrong)
  def resize(tempfile, options)
    Rails.logger.debug "  Resizing #{options.inspect}"
    
    command = %Q{mogrify -resize "#{options[:size]}" #{tempfile.path}}
    sub = Subexec.run(command, :timeout => 5)
    
    # any problem resizing this image?
    if sub.exitstatus != 0
      cleanup(tempfile)
      raise StandardError, "Command (#{command.inspect.gsub("\\", "")}) failed: #{{:status_code => sub.exitstatus, :output => sub.output}.inspect}"
    end
    
    Rails.logger.debug "  exitstatus: #{sub.exitstatus}, output: #{sub.output}"
  end
  private :resize
  
  
  # takes the current instance and upload its attached file to S3
  def upload(tempfile, filename)
    Rails.logger.debug "  Uploading filename..."
    
    s3_path = File.join(self.full_path_prefix, filename)
    AWS::S3::S3Object.store(s3_path, tempfile.open, AWS_CONFIG[:s3][:bucket_name], :access => :public_read)   # reopen the tempfile and write directly to S3
    
    Rails.logger.debug "    ** Uploaded image to S3: #{s3_path}"
  ensure
    tempfile.unlink
  end
  private :upload
  
  
  def get_size(tempfile)
    command = %Q{identify #{tempfile.path}}
    sub = Subexec.run(command, :timeout => 5)
    Rails.logger.debug "  #{command}: #{sub.output}"
    
    if sub.exitstatus != 0
      cleanup(tempfile)
      raise StandardError, "Command (#{command.inspect.gsub("\\", "")}) failed: #{{:status_code => sub.exitstatus, :output => sub.output}.inspect}"
    else
      return sub.output.split(' ')[2].split('x')
    end
  end
  
  
  # if there is a problem with trying to encode an image, eliminate the tempfile
  def cleanup(tempfile)
    return if tempfile.nil?
    tempfile.unlink
    tempfile = nil
  end
  private :cleanup
  
end
