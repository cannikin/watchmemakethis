class Permission < ActiveRecord::Base
  has_many :allowances
  has_many :roles, :through => :allowances
end
