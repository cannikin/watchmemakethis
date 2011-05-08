class Image < ActiveRecord::Base
  belongs_to :build
  
  validates :filename, :presence => true
end
