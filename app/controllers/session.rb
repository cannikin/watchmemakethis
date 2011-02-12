# login page
get '/login' do
  if logged_in?
    flash[:notice] = 'You are already logged in!'
    redirect '/admin'
  else
    @page_title = 'Login'
    haml :'session/login'
  end
end

get '/login2' do
  haml :login
end

# process login
post '/login/go' do
  unless params[:email].blank? or params[:password].blank?
    if user = User.authenticate(params)
      log_in_user(user)
      redirect '/admin'
    else
      flash[:notice] = 'No user was found with that email and password!'
      redirect '/login'
    end
  else
    flash[:notice] = 'Please enter both username and password!'
    redirect '/login'
  end
end

# logout
get '/logout' do
  log_out_user
  flash[:notice] = 'You have been logged out, come back soon!'
  redirect '/login'
end