# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :system do |f|
  f.next_twitter_call "MyString"
  f.twitpic_count 1
  f.yfrog_count 1
end