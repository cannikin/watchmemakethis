class Role < Sequel::Model
  one_to_many :users
end