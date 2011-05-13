class SiteController < ApplicationController
  
  before_filter :get_site_and_build

  def show
    @page_title = @site.name
  end


  # new build page
  def new
    @new_build = Build.new
  end
  
  
  # create a build
  def create
    @new_build = Build.new(params[:build])
    if @new_build.save
      
    else
      render :new
    end
  end
  
end
