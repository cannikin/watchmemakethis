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
  { :id => 1, :name => 'Plain Jane', :header_background => '#dddddd', :header_text_color => '#333333', :body_background => '#ffffff', :body_text_color => '#333333', :image_border: '15px solid #ffffff', :system => true },
  { :id => 2, :name => 'Dark Mark', :header_background => '#666666', :header_text_color => '#cccccc', :body_background => '#000000', :body_text_color => '#ffffff', :image_border: '15px solid #333333', :system => true },
  { :id => 3, :name => 'Lemon', :header_background => '#ffc965', :header_text_color => '#ffedcb', :body_background => '#ffedcb', :body_text_color => '#dc9410', :image_border: '15px solid #ffffff', :system => true },
  { :id => 4, :name => 'Sky', :header_background => '#6cbce6', :header_text_color => '#c3e4f5', :body_background => '#c3e4f5', :body_text_color => '#187db1', :image_border: '15px solid #ffffff', :system => true },
  { :id => 5, :name => 'Spring', :header_background => '#6ce692', :header_text_color => '#c3f5d2', :body_background => '#c3f5d2', :body_text_color => '#128336', :image_border: '15px solid #ffffff', :system => true },
  { :id => 6, :name => 'OMG Ponies!', :header_background => '#ee6a9a', :header_text_color => '#f9c6d8', :body_background => '#f9c6d8', :body_text_color => '#a01748', :image_border: '15px solid #ffffff', :system => true }
])
