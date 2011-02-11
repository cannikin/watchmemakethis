# admin home
get '/admin' do
  login_required
  haml :'admin/index'
end

# admin client list
get '/admin/clients' do
  login_required
end

# admin create client
get '/admin/clients/new' do
  login_required
end

# process create client
post '/admin/clients/create' do
  login_required
end

# client page
get '/admin/clients/:hashtag' do
  login_required
end
