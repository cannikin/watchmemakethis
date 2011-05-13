class ApplicationController < ActionController::Base
  
  protect_from_forgery
  helper_method :logged_in?, :current_user, :today
  
  
  def get_site_and_build
    if params[:site_path]
      if @site = Site.find_by_path(params[:site_path])
        if params[:build_path]
          if @build = @site.builds.find_by_path(params[:build_path])
            # ready to go, @site and @build are set
          else
            raise ActionController::RoutingError, 'Build not found'
          end
        end
      else
        raise ActionController::RoutingError, 'Site not found'
      end
    end
  end
  private :get_site_and_build
  
  
  # returns the current user
  def current_user
    if logged_in?
      begin
        @current_user ||= User.find(session[:user_id])
        #user
      rescue  # if a user is supposed to be logged in, but their user record can't be found, log them out
        log_out_user
        redirect_to root_path and return
      end
    else
      raise WatchMeMakeThis::UserNotLoggedIn, 'You tried to access the current_user, but no user is logged in.'
    end
  end
  private :current_user
  
  
  # is a user logged in?
  def logged_in?
    !session[:user_id].nil?
  end
  private :logged_in?
    
    
  # log a user in by creating their session
  def log_in_user(user)
    session[:user_id] = user.id
  end
  private :log_in_user
    
    
  # log a user out by removing their session 
  def log_out_user
    reset_session
    cookies.delete :remember
  end
  private :log_out_user
    
    
  # redirect a user back to a path defined in their session
  def redirect_back
    send_to = session[:return_to]
    session[:return_to] = nil
    redirect_to(send_to || root_path)
  end
  private :redirect_back
  
  
  # force the user to login
  def login_required
    unless logged_in?
      session[:return_to] = request.fullpath
      redirect_to login_path
    end
  end
  private :login_required
  
  
  # helper for keeping track of today, figuring in the user's time zone
  def today
    Time.zone.now.to_date
  end
  private :today
  
  
  # adds the role_missing class methods dynamically so you can do things like `before_filter :admin_required`
  def method_missing(method_id, *args)
    if match = matches_dynamic_role_check?(method_id)
      if logged_in?
        tokenize_roles(match.captures.first).each do |check|
          if current_user.role.name.downcase == check
            return true
          else
            flash[:error] = "You do not have access to this section of the site."
            redirect_to root_path
          end
        end
      else
        session[:return_to] = request.fullpath
        redirect_to login_path
      end
    else
      super
    end
  end
  private :method_missing
    
  
  # figures out if a method_missing is a role
  def matches_dynamic_role_check?(method_id)
    /^([a-zA-Z]\w*)_required$/.match(method_id.to_s)
  end
  private :matches_dynamic_role_check?
    
    
  # splits method_missing on _or_ to check multiple permissions
  def tokenize_roles(string_to_split)
    string_to_split.split(/_or_/)
  end
  private :tokenize_roles
  
end
