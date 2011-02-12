require 'sequel'

Sequel.connect('sqlite://db/development.db')
Dir.glob('./models/*').each { |m| require m }

Role.create(:name => 'admin')
Role.create(:name => 'client')

User.create :name => 'Rob Cameron', :email => 'cannikinn@gmail.com', :password => '13036a5c965bb73653a5de95b89ae4c2', :twitter => 'cannikin', :role_id => 1, :created_at => Time.now
