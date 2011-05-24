class BuildController < ApplicationController
  
  before_filter :get_site_and_build
  before_filter :login_required, :except => [:show]
  
  layout 'site'
  
  # list builds
  def index
    
  end
  
  
  # new build page
  def new
    @new_build = Build.new
  end
  
  
  # create a build
  def create
    site = current_user.sites.find_by_path(params[:site_path])
    @new_build = Build.new(params[:build].merge(:site_id => site.id))
    if @new_build.save
      redirect_to build_path(site.path, @new_build.path)
    else
      render :new
    end
  end
  
  
  # show the images for a build
  def show
    @page_title = @site.name + ':' + @build.name
    respond_to do |format|
      format.html
      format.json do
        if params[:since]
          images = @build.images.where(Image.arel_table[:id].gt(params[:since].to_i))
        else
          images = @build.images
        end
        render :json => images.collect { |image| image.attributes.merge(additional_image_attributes(image)) }
      end
    end

  end
  
  
  # upload an image to this build
  def upload
    file = params[:file]
    image = Image.create(:file => file, :build_id => @build.id)
    render :json => image.attributes.merge(additional_image_attributes(image))
    #render :partial => 'image', :locals => { :image => image, :hide => true }
  end
  
  
  # mark a build as archived (not viewable publicly)
  def archive
    
  end
  
  
  # remove a build and all associated images
  def destroy
    
  end
  
  
  # update an image's data
  def update_image
    if logged_in?
      if current_user.images.find(params[:id])
        image = Image.find(params[:id])
        image.update_attributes(params[:image])
        render :json => image.attributes.merge(additional_image_attributes(image))
      else
        render :nothing => true, :status => :bad_request
      end
    else
      render :nothing => true, :status => :authorization_required
    end
  end
  
  
  def destroy_image
    if image = @build.images.find(params[:id])
      image.destroy
      render :nothing => true
    else
      render :nothing => true, :status => :bad_request
    end
  end
  
  
  def additional_image_attributes(image)
    { :url_small => image.url(:small), 
      :url_large => image.url(:large), 
      :path => image_path(params[:site_path], params[:build_path], image.id) }
  end
  
  
end
