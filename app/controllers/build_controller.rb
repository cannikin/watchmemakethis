class BuildController < ApplicationController
  
  # show the images for a build
  def show
    session[:user_id] = 1
    if @site = Site.find_by_path(params[:site_path])
      unless @build = @site.builds.where(:path => params[:build_path]).first
        raise ActionController::RoutingError, 'Build not found'
      end
    end
  end
  
  
  # upload an image to this build
  def upload
    if site = Site.find_by_path(params[:site_path]) and build = Build.find_by_path(params[:build_path])
      file = params[:file]
      image = Image.create(:file => file, :build_id => build.id)
      render :partial => 'image', :locals => { :image => image }
    else
      render :nothing => true, :status => :bad_request
    end
  end
  
end
