require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  
  should have_many :allowances
  should have_many :permissions
  
  should validate_presence_of :name
  
end
