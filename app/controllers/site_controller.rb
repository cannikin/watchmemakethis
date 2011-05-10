class SiteController < ApplicationController

  def show
    unless @site = Site.find_by_path(params[:site_path])
      raise ActionController::RoutingError, 'Site not found'
    end
  end

end
