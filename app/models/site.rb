class Site < ActiveRecord::Base
  has_many    :builds
  belongs_to  :user
  
  validates :name, :presence => true
  validates :path, :presence => true, :uniqueness => true
end
