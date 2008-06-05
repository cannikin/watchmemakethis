require 'test_helper'

class CompsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:comps)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_comp
    assert_difference('Comp.count') do
      post :create, :comp => { }
    end

    assert_redirected_to comp_path(assigns(:comp))
  end

  def test_should_show_comp
    get :show, :id => comps(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => comps(:one).id
    assert_response :success
  end

  def test_should_update_comp
    put :update, :id => comps(:one).id, :comp => { }
    assert_redirected_to comp_path(assigns(:comp))
  end

  def test_should_destroy_comp
    assert_difference('Comp.count', -1) do
      delete :destroy, :id => comps(:one).id
    end

    assert_redirected_to comps_path
  end
end
