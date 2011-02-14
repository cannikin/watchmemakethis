# images can have comments

class Comment < Sequel::Model
  many_to_one :image
end