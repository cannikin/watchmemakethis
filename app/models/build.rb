class Build < ActiveRecord::Base
  belongs_to  :site
  has_many    :clients
  has_many    :images, :order => 'created_at desc'
  
  validates :name,    :presence => true
  validates_presence_of :path, :scope => :site_id
  validates_presence_of :hashtag, :scope => :site_id
end
