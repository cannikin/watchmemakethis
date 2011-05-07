require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  should "be valid" do
    assert Client.new.valid?
  end
end
