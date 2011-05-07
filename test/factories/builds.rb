# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :build do |f|
  f.user_id 1
  f.site_id 1
  f.name "MyString"
  f.hashtag "MyString"
  f.archived false
  f.public false
  f.last_login_at "2011-05-07 06:57:33"
  f.views 1
end