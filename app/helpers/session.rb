helpers do
  
  def log_in_user(user)
    session[:user_id] = user[:id] unless logged_in?
  end
  
  def log_out_user
    session[:user_id] = nil if logged_in?
  end
  
end