namespace :db do
  
  desc 'Drop the database'
  task :drop do
    print " Dropping database..."
    `rm db/development.db`
    puts "done"
  end
  
  desc 'Migrate the database'
  task :migrate do
    print " Migrating database..."
    `sequel -m db/migrations sqlite://db/development.db`
    puts "done"
  end
  
  namespace :migrate do
    desc 'Rebuild the database'
    task :reset do
      Rake::Task["db:drop"].execute
      Rake::Task["db:migrate"].execute
    end
  end
  
  desc 'Seed the database'
  task :seed do
    print " Seeding database..."
    `ruby db/seed.rb`
    puts "done"
  end
  
end
  
desc 'Start webserver'
task :server do
  `shotgun -p 4567`
end

desc "Report code statistics"
task :stats do
  require './vendor/code_statistics'
  
  STATS_DIRECTORIES = [
    %w(Controllers        app/controllers),
    %w(Helpers            app/helpers),
    %w(Models             app/models),
    %w(Libraries          lib/),
    %w(Migrations         db/migrations),
    %w(Views              app/views)
  ].collect { |name, dir| [ name, "./#{dir}" ] }.select { |name, dir| File.directory?(dir) }

  CodeStatistics.new(*STATS_DIRECTORIES).to_s
end
