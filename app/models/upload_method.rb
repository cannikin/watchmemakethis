class UploadMethod < ActiveRecord::Base
  
  has_many :images
  
  TWITTER = find_by_name('twitter')
  EMAIL   = find_by_name('email')
  DIRECT  = find_by_name('direct')
  
end
