require 'test_helper'

class SystemTest < ActiveSupport::TestCase
  should "be valid" do
    assert System.new.valid?
  end
end
