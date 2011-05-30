require 'test_helper'

class UploadMethodTest < ActiveSupport::TestCase
  should "be valid" do
    assert UploadMethod.new.valid?
  end
end
