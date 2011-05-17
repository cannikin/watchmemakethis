class Site < ActiveRecord::Base
  has_many    :builds
  belongs_to  :user
  has_one     :style
  
  validates :name, :presence => true, :length => { :maximum => 32, :minimum => 1 }
  validates :path, :presence => true, :uniqueness => true, :length => { :maximum => 32, :minimum => 1 }
end
