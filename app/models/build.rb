# these are the unique URLs  http://watchmemakethis.com/site_name/build_hashtag

class Build < Sequel::Model
  many_to_one :user
  many_to_one :site
  
  def path
    '/' + self.site.path + '/' + self.hashtag
  end
  
  def increment_views
    self.update :views => self.views + 1
  end
end