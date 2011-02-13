# these are the unique URLs  http://watchmemakethis.com/site_name/client_hashtag

class Client < Sequel::Model
  many_to_one :user
  many_to_one :client
  one_to_many :comments
end