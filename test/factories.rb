FactoryGirl.define do

  # users
  factory :user do
    first_name  Faker::Name.first_name
    last_name   Faker::Name.last_name
    email       Faker::Internet.email
    role_id     Role::OWNER
  end
  
  factory :twitter_user, :class => User do
    twitter     Faker::Internet.user_name
  end
  
end
