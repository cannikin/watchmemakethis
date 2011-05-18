class Role < ActiveRecord::Base
  
  has_many :allowances
  has_many :permissions, :through => :allowances
  
  validates :name, :presence => true
  
  ADMIN = 1
  OWNER = 2
  CLIENT = 3
  
end
