class SignupController < ApplicationController
  
  def new
    @user = User.new
    @site = Site.new
  end

  def create
    @user = User.new(params[:user].merge(:role_id => Role::OWNER))
    @site = Site.new(params[:site])
    
    if @user.valid? and @site.valid?
      @user.sites << @site
      @user.save and @site.save
      log_in_user @user
      redirect_to site_path(@site.path)
    else
      render :new
    end
    
  end

end
