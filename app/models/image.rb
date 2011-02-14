# a build has multiple images

class Image < Sequel::Model
  many_to_one :user
  many_to_one :build
  one_to_many :comments
end