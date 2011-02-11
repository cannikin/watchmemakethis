helpers do
  
  def log_in_user(user)
    session[:user_id] = user[:id] unless logged_in?
  end
  
  def log_out_user
    session[:user_id] = nil if logged_in?
  end
  
  def logged_in?
    !session[:user_id].nil?
  end
  
  def login_required
    unless logged_in?
      flash[:notice] = 'Please log in to continue!'
      redirect '/login'
    end
  end
  
  def current_user
    if logged_in?
      User[session[:user_id]]
    else
      raise NotLoggedIn, 'You tried to access the currently logged in user, but no one is logged in'
    end
  end
  
end