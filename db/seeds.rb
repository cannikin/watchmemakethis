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
