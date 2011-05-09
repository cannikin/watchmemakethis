class Role < ActiveRecord::Base
  has_many :allowances
  has_many :permissions, :through => :allowances
  
  validates :name, :presence => true
end