require 'sequel'

Sequel.connect('sqlite://db/development.db')
Dir.glob('./app/models/*').each { |m| require m }

Role.create(:name => 'admin')
Role.create(:name => 'client')

User.create :first_name => 'Rob', :last_name => 'Cameron', :email => 'cannikinn@gmail.com', :password => 'bosco', :twitter => 'cannikin', :role_id => 1, :created_at => Time.now

Build.create :name => "John Doe's Bookshelf", :hashtag => 'johndoe', :user_id => 1, :site_id => 1, :public => true

Site.create :user_id => 1, :name => 'Cameron Woodworks', :path => 'cameronwoodworks', :body_color => '#336699', :header_color => '#009900', :text_color => '#ffffff'
