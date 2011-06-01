class SessionController < ApplicationController
  
  # /login
  def new
    @page_title = 'Login'
    redirect_to(site_url(current_user.sites.first.path), :notice => 'You are already logged in!') if logged_in?
  end

  # /login/go
  def create
    @page_title = 'Login'
    if !logged_in?
      if user = User.authenticate(params[:email], params[:password])
        log_in_user(user)
        redirect_to(session[:return_to] || site_url(current_user.sites.first.path)) and return
      else
        flash[:notice] = 'Username or password not found'
        render :new
      end
    else
      redirect_to(site_url(current_user.sites.first.path), :notice => 'You are already logged in!')
    end
  end

  # /logout
  def destroy
    log_out_user
    redirect_to login_url
  end
  

end
