class BuildsController < ApplicationController
  # GET /builds
  # GET /builds.xml
  def index
    @builds = Build.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @builds }
    end
  end

  # GET /builds/1
  # GET /builds/1.xml
  def show
    @build = Build.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @build }
    end
  end

  # GET /builds/new
  # GET /builds/new.xml
  def new
    @build = Build.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @build }
    end
  end

  # GET /builds/1/edit
  def edit
    @build = Build.find(params[:id])
  end

  # POST /builds
  # POST /builds.xml
  def create
    @build = Build.new(params[:build])

    respond_to do |format|
      if @build.save
        format.html { redirect_to(@build, :notice => 'Build was successfully created.') }
        format.xml  { render :xml => @build, :status => :created, :location => @build }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @build.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /builds/1
  # PUT /builds/1.xml
  def update
    @build = Build.find(params[:id])

    respond_to do |format|
      if @build.update_attributes(params[:build])
        format.html { redirect_to(@build, :notice => 'Build was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @build.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /builds/1
  # DELETE /builds/1.xml
  def destroy
    @build = Build.find(params[:id])
    @build.destroy

    respond_to do |format|
      format.html { redirect_to(builds_url) }
      format.xml  { head :ok }
    end
  end
end
