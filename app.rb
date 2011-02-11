require 'bundler'
Bundler.require

Dir.glob('./helpers/*').each { |h| require h }

enable :sessions, :logging
set :haml, { :attr_wrapper => '"', :format => :html5 }

configure :development do
  set :database, 'sqlite://db/development.db'
  Dir.glob('./models/*').each { |m| require m }
end

# 404 page
not_found do
  @page_title = 'Not Found'
  haml :'404'
end

# general error page
error do
  @page_title = 'Error'
  haml :'500'
end

# login page
get '/login' do
  @page_title = 'Login'
  @users = User.all
  haml :login, :layout => :client_layout
end

# process login
post '/login/go' do
  if params[:email] and params[:password]
    if user = User.authenticate(params)
      log_in_user(user)
      redirect '/admin'
    else
      @flash = 'No user was found with that email and password!'
      redirect '/login'
    end
  else
    @flash = 'Please enter both username and password!'
    redirect '/login'
  end
end

# admin home
get '/admin' do
  
end

# admin client list
get '/admin/clients' do
  
end

# admin create client
get '/admin/clients/new' do
  
end

# process create client
post '/admin/clients/create' do
  
end

# client page
get '/admin/clients/:hashtag' do
  
end
