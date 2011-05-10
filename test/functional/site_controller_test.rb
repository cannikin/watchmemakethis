require 'test_helper'

class SiteControllerTest < ActionController::TestCase
    
  context "index action" do
    should "render index template" do
      get :index
      assert_template 'index'
    end
  end
      
  context "show action" do
    should "render show template" do
      get :show, :id => Site.first
      assert_template 'show'
    end
  end    
              
end
