helpers do
  
  # find a site from params
  def find_site(path)
    Site.find(:path => path)
  end
  
  
  # find a client from their hashtag and the site they should be a member of
  def find_client(hashtag, site)
    Client.find(:hashtag => hashtag, :site_id => site.id, :archived => false)
  end
  
end