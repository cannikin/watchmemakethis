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
    @images = @build.images.includes(:build => :site).order('position desc')
    
    respond_to do |format|
      format.html
      format.json do
        if params[:since]
          @images = @build.images.where(Image.arel_table[:id].gt(params[:since].to_i))
        end
        render :json => @images.collect { |image| image.attributes.merge(additional_image_attributes(image)) }
      end
    end

  end
  
  
  def edit
    @edit_build = @build
  end
  
  
  def update
    @edit_build = @build
    if @edit_build.update_attributes(params[:build])
      redirect_to build_path(@edit_build.site.path, @edit_build.path)
    else
      render :edit
    end
  end
  
  
  # upload an image to this build
  def upload
    file = params[:file]
    image = Image.create(:file => file, :build_id => @build.id, :upload_method => UploadMethod::DIRECT)
    render :json => image.attributes.merge(additional_image_attributes(image))
    #render :partial => 'image', :locals => { :image => image, :hide => true }
  end
  
  
  # mark a build as archived (not viewable publicly)
  def archive
    
  end
  
  
  # update the order of the images
  def order
    images = Image.find(params[:images])
    images.each do |image|
      new_position = params[:images].reverse.index(image.id.to_s)
      image.update_attributes :position => new_position+1
    end
    render :nothing => true
  end
  
  
  # remove a build and all associated images
  def destroy
    if current_user.builds.find(@build.id)
      @build.destroy
      redirect_to site_path(@site.path)
    else
      render 'public/404.html', :status => :not_found
    end
  end
  
  
  # update an image's data
  def update_image
    if owns_site?
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
