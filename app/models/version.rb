class Version < ActiveRecord::Base
  
  has_many :comments
  has_many :notes
  belongs_to :comp
  belongs_to :user
  
end
