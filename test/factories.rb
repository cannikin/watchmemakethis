FactoryGirl.define do
  
  # builds
  factory :build do
    name    'Build'
    path    'build'
    hashtag 'build'
  end
  
  # images
  factory :image do
    
  end
  
  # site
  factory :site do
    name  'Site'
    path  'factory_site'
  end
  
  # styles
  factory :style do
    # system  true
    name    'system style'
  end

  # users
  factory :user do
    first_name  Faker::Name.first_name
    last_name   Faker::Name.last_name
    email       Faker::Internet.email
    password    'password'
    role_id     Role::OWNER
  end
  
  factory :twitter_user, :class => User do
    twitter     Faker::Internet.user_name
  end
  
end
