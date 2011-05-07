class Site < ActiveRecord::Base
  has_many    :builds
  belongs_to  :user
end
