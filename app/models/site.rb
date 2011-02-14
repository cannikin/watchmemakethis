# sites are merely look and feels that an admin creates and can assign builds to

class Site < Sequel::Model
  many_to_one :user
  one_to_many :builds
end