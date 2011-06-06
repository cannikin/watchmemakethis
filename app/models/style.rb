class Style < ActiveRecord::Base
  
  has_many    :sites
  
  scope :system, where(:system => true)
  
end
