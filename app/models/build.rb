class Build < ActiveRecord::Base
  belongs_to  :site
  has_many    :clients
  has_many    :images, :dependent => :destroy
  
  validates :name,        :presence => true
  validates :path,        :presence => true, :length => { :maximum => 32, :minimum => 1 }, :format => { :with => /^[\w-]+$/ }
  validates_uniqueness_of :path, :scope => :site_id
  validates_length_of     :hashtag, :maximum => 32, :minimum => 1, :allow_blank => true
  validates_uniqueness_of :hashtag, :scope => :site_id
  validates_format_of     :hashtag, :with => /^[\w-]+$/
  
  scope :public, where(:public => true)
  scope :private, where(:public => false)
end
