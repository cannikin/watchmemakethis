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
  