class Comp < ActiveRecord::Base
  
  belongs_to :project
  has_many :versions
  
end
