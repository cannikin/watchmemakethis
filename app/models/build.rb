class Build < ActiveRecord::Base
  belongs_to  :site
  has_many    :clients
end
