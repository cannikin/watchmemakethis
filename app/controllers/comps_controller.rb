class CompsController < ApplicationController
  # GET /comps
  # GET /comps.xml
  def index
    @comps = Comp.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comps }
    end
  end

  # GET /comps/1
  # GET /comps/1.xml
  def show
    @comp = Comp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comp }
    end
  end

  # GET /comps/new
  # GET /comps/new.xml
  def new
    @comp = Comp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comp }
    end
  end

  # GET /comps/1/edit
  def edit
    @comp = Comp.find(params[:id])
  end

  # POST /comps
  # POST /comps.xml
  def create
    @comp = Comp.new(params[:comp])

    respond_to do |format|
      if @comp.save
        flash[:notice] = 'Comp was successfully created.'
        format.html { redirect_to(@comp) }
        format.xml  { render :xml => @comp, :status => :created, :location => @comp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comps/1
  # PUT /comps/1.xml
  def update
    @comp = Comp.find(params[:id])

    respond_to do |format|
      if @comp.update_attributes(params[:comp])
        flash[:notice] = 'Comp was successfully updated.'
        format.html { redirect_to(@comp) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comps/1
  # DELETE /comps/1.xml
  def destroy
    @comp = Comp.find(params[:id])
    @comp.destroy

    respond_to do |format|
      format.html { redirect_to(comps_url) }
      format.xml  { head :ok }
    end
  end
end
