require 'sequel'

Sequel.connect('sqlite://db/development.db')
Dir.glob('./models/*').each { |m| require m }

Role.create(:name => 'admin')
Role.create(:name => 'client')
