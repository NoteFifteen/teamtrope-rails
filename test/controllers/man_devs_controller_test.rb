require 'test_helper'

class ManDevsControllerTest < ActionController::TestCase
  setup do
    @man_dev = man_devs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:man_devs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create man_dev" do
    assert_difference('ManDev.count') do
      post :create, man_dev: { man_dev_decision: @man_dev.man_dev_decision, man_dev_end_date: @man_dev.man_dev_end_date, project_id: @man_dev.project_id }
    end

    assert_redirected_to man_dev_path(assigns(:man_dev))
  end

  test "should show man_dev" do
    get :show, id: @man_dev
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @man_dev
    assert_response :success
  end

  test "should update man_dev" do
    patch :update, id: @man_dev, man_dev: { man_dev_decision: @man_dev.man_dev_decision, man_dev_end_date: @man_dev.man_dev_end_date, project_id: @man_dev.project_id }
    assert_redirected_to man_dev_path(assigns(:man_dev))
  end

  test "should destroy man_dev" do
    assert_difference('ManDev.count', -1) do
      delete :destroy, id: @man_dev
    end

    assert_redirected_to man_devs_path
  end
end
