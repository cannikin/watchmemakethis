class BuildController < ApplicationController
  
  before_filter :get_site_and_build
  before_filter :login_required, :except => [:show]
  
  layout 'site'
  
  # list builds
  def index
    
  end
  
  
  # new build page
  def new
    if owns_site?
      @new_build = Build.new
    else
      render :file => 'public/404.html', :status => :not_found
    end
  end
  
  
  # create a build
  def create
    if owns_site?
      @new_build = Build.new(params[:build].merge(:site => @site))
      if @new_build.save
        redirect_to build_path(site.path, @new_build.path)
      else
        render :new
      end
    else
      render :file => 'public/404.html', :status => :not_found
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
    if owns_build?
      @edit_build = @build
    end
  end
  
  
  def update
    if owns_build?
      @edit_build = @build
      if @edit_build.update_attributes(params[:build])
        redirect_to build_path(@edit_build.site.path, @edit_build.path)
      else
        render :edit
      end
    end
  end
  
  
  # upload an image to this build
  def upload
    if owns_build?
      file = params[:file]
      image = Image.create(:file => file, :build_id => @build.id, :upload_method => UploadMethod::DIRECT)
      render :json => image.attributes.merge(additional_image_attributes(image))
    end
  end
  
  
  # mark a build as archived (not viewable publicly)
  def archive
    
  end
  
  
  # update the order of the images
  def order
    if owns_build?
      current_user.builds.find(@build.id).images.each do |image|
        new_position = params[:images].reverse.index(image.id.to_s)
        image.update_attributes :position => new_position+1
      end
      render :nothing => true
    end
  end
  
  
  # remove a build and all associated images
  def destroy
    if owns_build?
      @build.destroy
      redirect_to site_path(@site.path)
    else
      render 'public/404.html', :status => :not_found
    end
  end
  
  
  # update an image's data
  def update_image
    if owns_build?
      if current_user.images.find(params[:id])
        image = Image.find(params[:id])
        image.update_attributes(params[:image])
        render :json => image.attributes.merge(additional_image_attributes(image))
      else
        render :nothing => true, :status => :bad_request
      end
    end
  end
  
  
  def destroy_image
    if owns_build? and current_user.images.find(params[:id])
      Image.find(params[:id]).destroy
      render :nothing => true
    end
  end
  
  
  def additional_image_attributes(image)
    { :url_small => image.url(:small), 
      :url_large => image.url(:large), 
      :path => image_path(params[:site_path], params[:build_path], image.id) }
  end
  private :additional_image_attributes
  
  
end
