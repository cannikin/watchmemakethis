require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  
  should belong_to :user
  should belong_to :build
  
end
