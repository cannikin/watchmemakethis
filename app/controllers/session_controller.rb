class SessionController < ApplicationController
  
  # /login
  def new
  end

  # /login/go
  def create
    if !logged_in?
      if user = User.authenticate(params[:email], params[:password])
        log_in_user(user)
        redirect_to(session[:return_to] || site_path(current_user.sites.first.path)) and return
      else
        flash[:notice] = 'Username or password not found'
        render :new
      end
    else
      redirect_to(root_path, :notice => 'You are already logged in!')
    end
  end

  # /logout
  def destroy
    log_out_user
    redirect_to login_path
  end

end
