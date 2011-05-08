class Build < ActiveRecord::Base
  belongs_to  :site
  has_many    :clients
  
  validates :name,    :presence => true
  validates :path,    :presence => true, :scope => :site_id
  validates :hashtag, :presence => true, :scope => :site_id
end
