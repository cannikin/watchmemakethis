class SiteController < ApplicationController
  
  before_filter :get_site_and_build
  before_filter :must_own_site, :only => [:edit, :update]
  
  layout 'site'

  def show
    @page_title = @site.name
  end
  
  
  def edit
    @edit_user = current_user
    @edit_site = @site
  end
  
  
  def update
    @edit_user = current_user
    @edit_user.attributes = params[:user]
  
    @edit_site = @site
    @edit_site.attributes = params[:site]
  
    if @edit_user.valid? and @edit_site.valid?
      @edit_user.save
      @edit_site.save
      redirect_to site_path(@edit_site.path)
    else
      render :edit
    end
  end

  
end
