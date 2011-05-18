require 'test_helper'

class SignupControllerTest < ActionController::TestCase
        
  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
    end
  end
    
  context "create action" do
    should "render new template when model is invalid" do
      Signup.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      Signup.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to
    end
  end
          
end
