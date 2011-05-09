class Image < ActiveRecord::Base
  belongs_to :build
  
  validates :filename, :presence => true
  
  # for holding a file that's about to be uploaded (this isn't actually saved to the DB)
  attr_accessor :file
  
  OUTPUT_FORMAT = 'jpg'
  META = { :small => { :width => 150, :height => 150, :prefix => 's_'},
           :large => { :width => 1024, :height => 1024, :prefix => 'l_'},
           :original => { :prefix => 'o_'}}
  
  
  # prefix to the path for this image (not including filename)
  def full_path_prefix
    self.build.site.path + '/' + self.build.path
  end

  
  # the full URL
  def url(size=:small)
    S3_CONFIG[:cdn] + self.full_path_prefix + '/' + META[size][:prefix] + self.filename
  end
  
           
  # takes the current instance and upload its attached file to S3
  def upload(options={})
    if self.file
      remote_filename = UUID.new.generate + '.' + OUTPUT_FORMAT # filename becomes the timestamp to avoid name conflicts
      
      # if we received a specific size name, or a width and height, use those. 
      # Otherwise, create a default large and small size
      if options[:size]
        self.filename = resize_and_upload_image(options[:size], remote_filename)
      elsif options[:width] and options[:height]
        self.filename = resize_and_upload_image(options, remote_filename)
      else
        self.filename = resize_and_upload_image(:original, remote_filename)
        resize_and_upload_image(:large, remote_filename)
        resize_and_upload_image(:small, remote_filename)
        return true
      end

    else
      raise 'No file attached to photo'
    end
  end
  
  
  # Creates and uploads a single image (the model should know everything it needs to about an image, including how to save itself wherever)
  # Returns the name of the file it just uploaded (or throws an error if something goes wrong)
  def resize_and_upload_image(size, filename)
    resize_command = nil
    
    case size
    when Symbol
      resize_command = "#{META[size][:width]}x#{META[size][:height]}>" if META[size][:width] and META[size][:height]
    when Hash
      resize_command = "#{size[:width]}x#{size[:height]}>" if size[:width] and size[:height]
    end
    
    temp = Tempfile.new(['watch','.jpg'])
    temp << File.read(self.file)
    `mogrify -resize '#{resize_command}' #{temp.path}`
    
    #image = MiniMagick::Image.open(self.file)
    #final_image_name = filename
    #final_image_name = META[size][:prefix] + final_image_name if (META[size] and META[size][:prefix]) or size[:prefix]
    #s3_path = File.join(self.full_path_prefix, final_image_name)
    #image.resize(resize_command) if resize_command
    
    final_image_name = filename
    final_image_name = META[size][:prefix] + final_image_name if (META[size] and META[size][:prefix]) or size[:prefix]
    s3_path = File.join(self.full_path_prefix, final_image_name)
    AWS::S3::S3Object.store(s3_path, temp.open, S3_CONFIG[:bucket_name], :access => :public_read)   # reopen the tempfile and write directly to S3
    Rails.logger.debug "** Uploaded image to S3: #{s3_path}"
    
    return filename
  ensure
    #temp.close
  end
  private :resize_and_upload_image
  
end
