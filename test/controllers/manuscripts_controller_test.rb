require 'test_helper'

class ManuscriptsControllerTest < ActionController::TestCase
  setup do
    @manuscript = manuscripts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manuscripts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manuscript" do
    assert_difference('Manuscript.count') do
      post :create, manuscript: {  }
    end

    assert_redirected_to manuscript_path(assigns(:manuscript))
  end

  test "should show manuscript" do
    get :show, id: @manuscript
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manuscript
    assert_response :success
  end

  test "should update manuscript" do
    patch :update, id: @manuscript, manuscript: {  }
    assert_redirected_to manuscript_path(assigns(:manuscript))
  end

  test "should destroy manuscript" do
    assert_difference('Manuscript.count', -1) do
      delete :destroy, id: @manuscript
    end

    assert_redirected_to manuscripts_path
  end
end
