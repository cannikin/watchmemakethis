class BuildController < ApplicationController
  
  def show
    if @site = Site.find_by_path(params[:site_path])
      unless @build = @site.builds.where(:path => params[:build_path]).first
        raise ActionController::RoutingError, 'Build not found'
      end
    end
  end

end
