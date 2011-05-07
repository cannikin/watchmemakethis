# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |f|
  f.first_name "MyString"
  f.last_name "MyString"
  f.email "MyString"
  f.password "MyString"
  f.twitter "MyString"
  f.role_id 1
  f.last_login_at "2011-05-06 22:59:40"
  f.login_count 1
end