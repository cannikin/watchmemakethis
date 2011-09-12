class Admin::HomeController < Admin::AdminController
  
  def index
    @newest_sites = Site.includes(:user, :builds).order('created_at desc').limit(10)
    @recent_uploads = Image.includes(:build => :site).order('created_at desc').limit(25)
  end
  
end