require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  should have_many :allowances
  should have_many :roles
  
  should validate_presence_of :name
end
