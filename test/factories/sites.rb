# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :site do |f|
  f.user_id 1
  f.name "MyString"
  f.path "MyString"
  f.show_in_directory false
end