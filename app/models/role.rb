class Role < Sequel::Model
  
  one_to_many :users
  
  ADMIN = 1
  CLIENT = 2
  
end