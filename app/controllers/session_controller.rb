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
  
  
  # page user goes to to send a reset password email
  def forgot_password
    @page_title = 'Forgot Password'
  end
  
  
  # send reset password
  def send_reset_email
    @page_title = 'Forgot Password'
    if params[:email] and user = User.find_by_email(params[:email])
      Notifier.forgot_password(user, request.host).deliver
    else
      flash[:notice] = 'No user was found with that email address, please try again!'
      render :forgot_password
    end
  end
  
  
  # page to reset password
  def reset_password
    @page_title = 'Reset Password'
    unless params[:t] and @user = User.find_by_uuid(params[:t])
      render_404
    end
  end
  
  
  def save_password
    @page_title = 'Reset Password'
    if params[:t] and user = User.find_by_uuid(params[:t])
      if user.update_attributes :password => params[:password]
        log_out_user
        log_in_user(user)
        redirect_to(session[:return_to] || site_url(current_user.sites.first.path)) and return
      else
        flash[:notice] = "Password could not be updated: password #{user.errors[:password].first}"
        render :reset_password
      end
    end
  end
  

end
