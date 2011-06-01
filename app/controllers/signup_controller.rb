class SignupController < ApplicationController
  
  def new
    @page_title = 'Signup'
    @user = User.new
    @site = Site.new
  end

  def create
    @page_title = 'Signup'
    @user = User.new(params[:user].merge(:role_id => Role::OWNER))
    @site = Site.new(params[:site])
    
    if @user.valid? and @site.valid?
      @user.sites << @site
      @user.save and @site.save
      log_in_user @user
      
      begin
        Notifier.welcome(@user, @site, request.host).deliver 
      rescue => e 
        Rails.logger.error "Problem sending welcome email to #{@user.email}"
        notify_hoptoad(e)
      end
      
      redirect_to site_path(@site.path)
    else
      render :new
    end
    
  end

end
