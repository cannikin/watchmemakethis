class UploadMethod < ActiveRecord::Base
  
  has_many :images
  
  TWITTER = 1
  EMAIL   = 2
  DIRECT  = 3
  
end
