# signup page
get '/signup' do
  @page_title = 'Create Your Account'
  haml :'signup/index'
end

# create account
post '/signup/create' do
  @page_title = 'Create Your Account'
end

# ajax check for email address in use
get '/signup/check/email' do
  User.where(:email => params[:email]).any? ? status(200) : status(404)
end

# ajax check for twitter account in use
get '/signup/check/twitter' do
  User.where(:twitter => params[:twitter]).any? ? status(200) : status(404)
end

# ajax check for subdomain in use
get '/signup/check/subdomain' do
  Site.where(:subdomain => params[:subdomain]).any? ? status(200) : status(404)
end
