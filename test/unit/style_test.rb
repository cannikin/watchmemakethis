require 'test_helper'

class StyleTest < ActiveSupport::TestCase
  should "be valid" do
    assert Style.new.valid?
  end
end
