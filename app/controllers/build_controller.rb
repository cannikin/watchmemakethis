class BuildController < ApplicationController
  
  before_filter :get_site_and_build
  
  # show the images for a build
  def show
    @page_title = @site.name + ':' + @build.name
  end
  
  
  # upload an image to this build
  def upload
    file = params[:file]
    image = Image.create(:file => file, :build_id => @build.id)
    render :partial => 'image', :locals => { :image => image }
  end
  
  
  # mark a build as archived (not viewable publicly)
  def archive
    
  end
  
  
  # remove a build and all associated images
  def destroy
    
  end
  
  
  def destroy_image
    if image = @build.images.find(params[:id])
      image.destroy
      render :nothing => true
    else
      render :nothing => true, :status => :bad_request
    end
  end
  
  
end
