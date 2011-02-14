# these are the unique URLs  http://watchmemakethis.com/site_name/build_hashtag

class Build < Sequel::Model
  many_to_one :user
  many_to_one :site
  one_to_many :clients
  
  alias :creator :user
  
  # the users who have access to this build
  def users
    self.clients.collect(&:build)
  end
  
  # the URL to this build
  def path
    '/' + self.site.path + '/' + self.hashtag
  end
  
  # add to the view count
  def increment_views
    self.update :views => self.views + 1
  end
end