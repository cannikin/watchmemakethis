class User < ActiveRecord::Base
  has_many    :sites
  belongs_to  :role
  #has_many    :allowances, :through => :role
  #has_many    :permissions, :through => :allowances
end
