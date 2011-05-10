# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :style do |f|
  f.site_id 1
  f.header_background "MyString"
  f.header_text_color "MyString"
  f.body_background "MyString"
  f.body_text_color "MyString"
  f.image_border "MyString"
end