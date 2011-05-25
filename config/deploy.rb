require 'bundler/capistrano'

# RVM helpers
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))  # Add RVM's lib directory to the load path.
require "rvm/capistrano"                                # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2-p180@watchmemakethis'      # Or whatever env you want it to run in.
set :rvm_type, :user
set :rails_env, 'production'

set :application, "watchmemakethis"

set :scm,           :git
set :repository,    'git@github.com:cannikin/watchmemakethis.git'
set :deploy_via,    :copy
set :deploy_to,     '/var/www'

set :use_sudo, false
set :user, 'ubuntu'

role :web, "ec2-50-17-249-203.compute-1.amazonaws.com"                          # Your HTTP server, Apache/etc
role :app, "ec2-50-17-249-203.compute-1.amazonaws.com"                          # This may be the same as your `Web` server
role :db,  "ec2-50-17-249-203.compute-1.amazonaws.com", :primary => true        # This is where Rails migrations will run


namespace :rake do  
  desc "Run a task on a remote server."  
  # run like: cap staging rake:invoke task=a_certain_task  
  task :invoke do  
    run("cd #{release_path}; /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")  
  end  
end


namespace :deploy do

  desc 'First-time setup of shared/config'
  task :config_setup, :roles => :app do
    run "mkdir -p #{shared_path}/system"
    run "mkdir -p #{shared_path}/config"
    Dir.glob(File.join('config','*_sample.yml')).each do |file|
      put File.read(file), "#{shared_path}/#{file.gsub('_sample','')}"
    end
  end
  
  desc 'Symlinks shared directores to release path'
  task :symlink_shared_dirs, :roles => :app do
    symlink_database_yml
    symlink_amazon_s3_yml
  end
  
  desc 'Create symlink to database.yml in shared directory'
  task :symlink_database_yml, :roles => :app do
    run "ln -nsf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  
  desc 'Create symlink to amazon_s3.yml in shared directory'
  task :symlink_amazon_s3_yml, :roles => :app do
    run "ln -nsf #{shared_path}/config/amazon_s3.yml #{release_path}/config/amazon_s3.yml"
  end
  
  desc "Precompile assets"
  task :create_assets, :roles => :web do
    run rake_task("assets:precompile")
  end
  
  desc "Start application instances"
  task :start, :roles => :web do
    run "cd #{current_path} && bundle exec unicorn -E #{rails_env} -c config/unicorn.rb -D"
  end

  desc "Stop application instances"
  task :stop, :roles => :web do
    run "kill -QUIT `cat #{current_path}/tmp/pids/unicorn.pid`"
  end

  desc "Restart application instances"
  task :restart, :roles => :web do
    run "kill -USR2 `cat #{current_path}/tmp/pids/unicorn.pid`"
  end
  
end


namespace :web do
  desc 'Serve up a custom maintenance page'
  task :disable, :roles => :web do
    require 'erb'
    on_rollback { run "rm #{shared_path}/system/maintenance.html" }

    reason = ENV['REASON'] || nil
    deadline = ENV['UNTIL'] || nil
    
    template = File.read("app/views/layouts/maintenance.html.erb")
    page = ERB.new(template).result(binding)
    #page = Haml::Engine.new(template).render(Object.new, :reason => ENV['REASON'] || nil, :deadline => ENV['UNTIL'] || nil)
    
    put page, "#{shared_path}/system/maintenance.html", :mode => 0644
  end
  
  desc 'Remove maintence page'
  task :enable, :roles => :web do
     run "rm #{shared_path}/system/maintenance.html"
  end
  
  desc "Start web server"
  task :start, :roles => :web do
    sudo "service nginx start"
  end

  desc "Stop web server"
  task :stop, :roles => :web do
    sudo "service nginx stop"
  end

  desc "Restart web server"
  task :restart, :roles => :web do
    sudo "service nginx restart"
  end
end


namespace :admin do
  desc <<-DESC
    Restart the whole server. USE WITH CAUTION!!
  DESC
  task :restart, :roles => :app do
    sudo "shutdown -r now"
  end
end

# symlink database and amazon_s3 files after a deploy
after 'deploy:setup', 'deploy:config_setup'
after 'deploy:update_code', 'deploy:symlink_shared_dirs'

# cleanup old releases (keep the last 5)
after 'deploy', 'deploy:cleanup'
after 'deploy:migrations', 'deploy:cleanup'

after 'deploy:update_code', 'deploy:create_assets'
