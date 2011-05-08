# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :image do |f|
  f.build_id 1
  f.filename "MyString"
  f.description "MyText"
end