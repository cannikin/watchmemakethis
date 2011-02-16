helpers do
  
  def versioned_stylesheet(stylesheet)
    "/stylesheets/#{stylesheet}.css?" + File.mtime(File.join(Sinatra::Application.views, "stylesheets", "#{stylesheet}.sass")).to_i.to_s
  end
  
  def versioned_javascript(js)
    "/javascripts/#{js}.js?" + File.mtime(File.join(Sinatra::Application.public, "javascripts", "#{js}.js")).to_i.to_s
  end
    
  def logged_in?
    !session[:user_id].nil?
  end
  
  def admin?
    logged_in? and current_user.admin?
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