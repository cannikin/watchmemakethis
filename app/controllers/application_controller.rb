class ApplicationController < ActionController::Base
  
  protect_from_forgery
  helper_method :logged_in?, :current_user, :today, :owns_site?, :owns_build?
  
  before_filter :login_if_remember
  
  
  def login_if_remember
    if !logged_in? and cookies[:remember] and user = User.find_by_uuid(cookies[:remember])
      Rails.logger.debug "Auto-logging in user #{user.email} based on remember cookie"
      log_in_user(user)
    end
  end
  private :login_if_remember
  
  
  # create @site and @build instance variables based on URL paths
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
    Rails.logger.debug "Logging in user #{user.email}"
    session[:user_id] = user.id
    cookies[:remember] = {:value => user.uuid, :expires => 10.years.from_now }
  end
  private :log_in_user
    
    
  # log a user out by removing their session 
  def log_out_user
    Rails.logger.debug "Logging out user #{current_user.email}"
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
  
  
  # determines whether a user is viewing their own site
  def owns_site?
    logged_in? and @site and current_user == @site.owner
  end
  
  
  def must_own_site
    render_404 unless owns_site?
  end
  
  
  # determines whether a user is viewing their own site
  def owns_build?
    owns_site? and current_user.builds.find(@build.id)
  end
  
  
  def must_own_build
    render_404 unless owns_build?
  end
  
  
  def render_404
    render :file => 'public/404.html', :layout => false, :status => :not_found and return
  end
  
  
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
