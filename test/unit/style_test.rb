require 'test_helper'

class StyleTest < ActiveSupport::TestCase
  
  should have_many :sites
  
  should "have a scope that returns system-defined styles" do
    system_style = Factory.create :style, :system => true
    user_style = Factory.create :style, :system => false
    
    assert_equal [system_style], Style.system
  end
  
end
