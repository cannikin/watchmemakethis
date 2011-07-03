class Site < ActiveRecord::Base
  
  has_many    :builds, :dependent => :destroy
  belongs_to  :user
    alias :owner :user
  belongs_to  :style
  
  validates :name, :presence => true, :length => { :maximum => 32, :minimum => 1 }
  validates_presence_of   :path
  validates_uniqueness_of :path, :message => 'This URL is already taken, please try another.'
  validates_length_of     :path, :in => 1..32
  validates_exclusion_of  :path, :in => %w{admin api blog build forgot help images info login logout pricing reset signup site style styles theme themes}, :message => 'This URL is reserved, please try another.' 
  validates_format_of     :path, :with => /^[\w-]+$/, :message => 'Your site name may only include letters, numbers, _underscores_ and -dashes-'
  
end
