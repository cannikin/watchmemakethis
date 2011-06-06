class Site < ActiveRecord::Base
  
  has_many    :builds, :dependent => :destroy
  belongs_to  :user
    alias :owner :user
  belongs_to  :style
  
  validates :name, :presence => true, :length => { :maximum => 32, :minimum => 1 }
  validates :path, :presence => true, :length => { :maximum => 32, :minimum => 1 }, :exclusion => { :in => %w{admin api blog build help images info login logout pricing signup site style styles theme themes}, :message => 'This URL is reserved, please try another.' }
  validates_uniqueness_of :path, :message => 'This URL is already taken, please try another.'
  
end
