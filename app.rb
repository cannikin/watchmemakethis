require 'bundler'
Bundler.require

# require stuff in various directories
['./app/controllers/*','./app/helpers/*','./lib/*','./config/initializers/*'].each { |f| Dir.glob(f).each { |r| require r } }

enable :sessions, :logging
set :views, './app/views'
use Rack::Flash, :sweep => true

configure do
  environment = Sinatra::Application.environment.to_s
  set :environment, environment
  
  # models
  db_config = YAML::load(File.open(File.join(File.dirname(__FILE__),'config','database.yml'))).symbolize_keys
  puts db_config.inspect
  set :database, db_config[environment.to_sym][:connect]
  Dir.glob('./app/models/*').each { |m| require m }
  
  # amazon
  s3_config = YAML.load(File.read(File.join('config','amazon_s3.yml'))).symbolize_keys[environment.to_sym]
  set :s3_config, s3_config
  AWS::S3::Base.establish_connection!(:access_key_id => s3_config[:access_key_id], :secret_access_key => s3_config[:secret_access_key])         # get S3 ready
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