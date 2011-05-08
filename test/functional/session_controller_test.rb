require 'test_helper'

class SessionControllerTest < ActionController::TestCase
        
  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
    end
  end
    
  context "create action" do
    should "render new template when model is invalid" do
      Session.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      Session.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to
    end
  end
        
  context "destroy action" do
    should "destroy model and redirect to index action" do
      session = Session.first
      delete :destroy, :id => session
      assert_redirected_to
      assert !Session.exists?(session.id)
    end
  end
    
end
