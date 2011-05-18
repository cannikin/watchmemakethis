class Site < ActiveRecord::Base
  
  has_many    :builds
  belongs_to  :user
  belongs_to  :style
  
  validates :name, :presence => true, :length => { :maximum => 32, :minimum => 1 }
  validates :path, :presence => true, :length => { :maximum => 32, :minimum => 1 }
  validates_uniqueness_of :path, :message => 'is already taken, please choose another site name'
  
end
