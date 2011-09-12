class Admin::SitesController < Admin::AdminController

  def index
    @sites = Site.order('created_at desc')
  end

end
