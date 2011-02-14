# Join table to connect users to builds

class Client < Sequel::Model
  many_to_one :user
  many_to_one :build
end