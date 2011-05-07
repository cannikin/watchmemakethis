require 'test_helper'

class BuildTest < ActiveSupport::TestCase
  should "be valid" do
    assert Build.new.valid?
  end
end
