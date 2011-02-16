# a build has multiple images

class Image < Sequel::Model
  many_to_one :user
  many_to_one :build
  one_to_many :comments
  
  # url to this image on S3
  def url
    "http://#{options.s3_config[:url]}/#{self.build.site.path}/#{self.build.hashtag}/#{self.filename}"
  end
end
