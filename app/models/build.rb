class Build < ActiveRecord::Base
  belongs_to  :site
  has_many    :clients
  has_many    :images, :order => 'created_at desc'
  
  validates :name,    :presence => true
  validates_presence_of :path
  validates_uniqueness_of :path, :scope => :site_id
  validates_uniqueness_of :hashtag, :scope => :site_id, :allow_blank => true
  
  scope :public, where(:public => true)
  scope :private, where(:public => false)
  
  def last_updated_at
    if self.images.any?
      return self.images.first.created_at
    else
      return nil
    end
  end
  
end
