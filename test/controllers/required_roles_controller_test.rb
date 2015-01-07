require 'test_helper'

class RequiredRolesControllerTest < ActionController::TestCase
  setup do
    @required_role = required_roles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:required_roles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create required_role" do
    assert_difference('RequiredRole.count') do
      post :create, required_role: { project_type_id: @required_role.project_type_id, role_id: @required_role.role_id, suggested_percent: @required_role.suggested_percent }
    end

    assert_redirected_to required_role_path(assigns(:required_role))
  end

  test "should show required_role" do
    get :show, id: @required_role
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @required_role
    assert_response :success
  end

  test "should update required_role" do
    patch :update, id: @required_role, required_role: { project_type_id: @required_role.project_type_id, role_id: @required_role.role_id, suggested_percent: @required_role.suggested_percent }
    assert_redirected_to required_role_path(assigns(:required_role))
  end

  test "should destroy required_role" do
    assert_difference('RequiredRole.count', -1) do
      delete :destroy, id: @required_role
    end

    assert_redirected_to required_roles_path
  end
end
