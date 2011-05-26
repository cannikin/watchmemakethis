class SessionController < ApplicationController
  
  # /login
  def new
    redirect_to(site_path(current_user.sites.first.path), :notice => 'You are already logged in!') if logged_in?
  end

  # /login/go
  def create
    if !logged_in?
      if user = User.authenticate(params[:email], params[:password])
        log_in_user(user)
        redirect_to(session[:return_to] || site_path(current_user.sites.first.path))
        Rails.logger.debug response.headers.inspect
      else
        flash[:notice] = 'Username or password not found'
        render :new
      end
    else
      redirect_to(site_path(current_user.sites.first.path), :notice => 'You are already logged in!')
    end
    
  end

  # /logout
  def destroy
    log_out_user
    redirect_to login_path
  end

end
