class BuildController < ApplicationController
  
  before_filter :get_site_and_build
  before_filter :must_own_site, :except => [:index, :show]
  before_filter :must_own_build, :except => [:index, :show, :new, :create]
  before_filter :must_own_image, :only => [:update_image, :destroy_image]
  
  protect_from_forgery :except => [:order]
  
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
    @new_build = Build.new(params[:build].merge(:site => @site))
    if @new_build.save
      redirect_to build_path(@site.path, @new_build.path)
    else
      render :new
    end
  end
  
  
  # show the images for a build
  def show
    @page_title = @site.name + ':' + @build.name
    @images = @build.images.includes(:build => :site).order("position #{@build.image_order}")
    
    respond_to do |format|
      format.html
      format.json do
        if params[:since]
          @images = @build.images.where(Image.arel_table[:position].gt(params[:since].to_i))
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
    images = []
    params[:files].each do |file|
      images << Image.create(:file => file, :build_id => @build.id, :upload_method_id => UploadMethod::DIRECT)
    end
    #render :json => image.attributes.merge(additional_image_attributes(image)), :content_type => 'text/javascript'
    render :json => images.collect { |i| i.attributes.merge(additional_image_attributes(i)) }, :content_type => 'text/javascript'
  end
  
  
  # mark a build as archived (not viewable publicly)
  def archive
    
  end
  
  
  # update the order of the images
  def order
    current_user.builds.find(@build.id).images.each do |image|
      if new_position = params[:images].reverse.index(image.id.to_s)
        image.update_attributes :position => new_position+1
      end
    end
    render :nothing => true
  end
  
  
  # remove a build and all associated images
  def destroy
    @build.destroy
    redirect_to site_path(@site.path)
  end
  
  
  # update an image's data
  def update_image
    image = Image.find(params[:id])
    image.update_attributes(params[:image])
    render :json => image.attributes.merge(additional_image_attributes(image))
  end
  
  
  def destroy_image
    Image.find(params[:id]).destroy
    render :nothing => true
  end
  
  
  def must_own_image
    render_404 unless current_user.images.find(params[:id])
  end
  
  
  def additional_image_attributes(image)
    { :url_small => image.url(:small), 
      :url_large => image.url(:large), 
      :path => image_path(params[:site_path], params[:build_path], image.id) }
  end
  private :additional_image_attributes
  
  
end
