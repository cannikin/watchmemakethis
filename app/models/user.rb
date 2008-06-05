class User < ActiveRecord::Base
  
  has_many :comments
  has_many :notes
  has_many :versions
  
end
