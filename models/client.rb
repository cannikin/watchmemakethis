class Client < Sequel::Model
  many_to_one :user
end