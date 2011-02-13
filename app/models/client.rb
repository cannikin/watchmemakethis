# these are the unique URLs  http://watchmemakethis.com/site_name/client_hashtag

class Client < Sequel::Model
  many_to_one :user
  many_to_one :site
  
  def name
    self.first_name + ' ' + self.last_name
  end
  
  def path
    '/' + self.site.path + '/' + self.hashtag
  end
end