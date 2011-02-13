# sites are merely look and feels that a user creates and can assign to a client

class Site < Sequel::Model
  many_to_one :user
  one_to_many :clients
end