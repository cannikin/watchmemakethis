require 'bundler'
Bundler.require

# require stuff in various directories
['./app/controllers/*','./app/helpers/*','./lib/*'].each { |f| Dir.glob(f).each { |r| require r } }

enable :sessions, :logging
set :views, './app/views'
use Rack::Flash, :sweep => true

configure do
  config = YAML::load(File.open(File.join(File.dirname(__FILE__),'config','database.yml')))
  environment = Sinatra::Application.environment.to_s
  set :database, config[environment]['connect']
  Dir.glob('./app/models/*').each { |m| require m }
end

configure :development do
  set :haml, { :attr_wrapper => '"', :format => :html5, :ugly => false }
end

configure :production do
  set :haml, { :attr_wrapper => '"', :format => :html5, :ugly => true }
end

# 404 page
not_found do
  @page_title = 'Not Found'
  '404'
end

# general error page
error do
  @page_title = 'Error'
  haml :'500'
end

# see /controllers for endpoints