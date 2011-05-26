# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
Role.create([
  {:id => 1, :name => 'admin'},
  {:id => 2, :name => 'owner'},
  {:id => 3, :name => 'client'}])

System.create :twitter_username => '@watchmemake', :next_twitter_call => 'http://search.twitter.com/search.json?q=to%3Awatchmemake'

# some default styles
Style.create([
  { :id => 1, :name => 'Plain Jane', :header_background => '#dddddd', :header_text_color => '#333333', :body_background => '#ffffff', :body_text_color => '#ffffff', :image_border => '15px solid #ffffff', :system => true },
  { :id => 2, :name => 'Dark Mark', :header_background => '#666666', :header_text_color => '#cccccc', :body_background => '#000000', :body_text_color => '#333333', :image_border => '15px solid #333333', :system => true },
  { :id => 3, :name => 'Lemon', :header_background => '#ffc965', :header_text_color => '#ffedcb', :body_background => '#ffedcb', :body_text_color => '#dc9410', :image_border => '15px solid #ffffff', :system => true },
  { :id => 4, :name => 'Sky', :header_background => '#6cbce6', :header_text_color => '#c3e4f5', :body_background => '#c3e4f5', :body_text_color => '#187db1', :image_border => '15px solid #ffffff', :system => true },
  { :id => 5, :name => 'Spring', :header_background => '#6ce692', :header_text_color => '#c3f5d2', :body_background => '#c3f5d2', :body_text_color => '#128336', :image_border => '15px solid #ffffff', :system => true },
  { :id => 6, :name => 'OMG Ponies!', :header_background => '#ee6a9a', :header_text_color => '#f9c6d8', :body_background => '#f9c6d8', :body_text_color => '#a01748', :image_border => '15px solid #ffffff', :system => true },
  { :id => 7, :name => 'Stormy Sea', :header_background => '#37415f', :header_text_color => '#9ea3b3', :body_background => '#9ea3b3', :body_text_color => '#37415f', :image_border => '15px solid #ffffff', :system => true },
  { :id => 8, :name => 'Dark Witch', :header_background => '#4c5933', :header_text_color => '#d3febf', :body_background => '#879e89', :body_text_color => '#e9fb78', :image_border => '15px solid #e9fb78', :system => true },
  { :id => 9, :name => 'Cape Cod', :header_background => '#e20530', :header_text_color => '#ffffff', :body_background => '#ffffff', :body_text_color => '#2a2f66', :image_border => '15px solid #eeeeee', :system => true },
  { :id => 10, :name => 'Library', :header_background => '#884d11', :header_text_color => '#492909', :body_background => '#eddac8', :body_text_color => '#834618', :image_border => '15px solid #f6f1e7', :system => true },
  { :id => 11, :name => 'Cantalope', :header_background => '#ba2618', :header_text_color => '#f4ae8a', :body_background => '#f4ae8a', :body_text_color => '#f44b29', :image_border => '15px solid #f2e3d4', :system => true },
  { :id => 11, :name => '1974', :header_background => '#f48f34', :header_text_color => '#593200', :body_background => '#593200', :body_text_color => '#f48f34', :image_border => '15px solid #fde74e', :system => true },
  { :id => 12, :name => '1978', :header_background => '#e58f28', :header_text_color => '#fadf3a', :body_background => '#f8efb8', :body_text_color => '#633f0b', :image_border => '15px solid #a2b43e', :system => true }
])
