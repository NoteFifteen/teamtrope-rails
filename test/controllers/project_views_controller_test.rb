require 'test_helper'

class ProjectViewsControllerTest < ActionController::TestCase
  setup do
    @project_view = project_views(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_views)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_view" do
    assert_difference('ProjectView.count') do
      post :create, project_view: { project_type_id: @project_view.project_type_id }
    end

    assert_redirected_to project_view_path(assigns(:project_view))
  end

  test "should show project_view" do
    get :show, id: @project_view
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_view
    assert_response :success
  end

  test "should update project_view" do
    patch :update, id: @project_view, project_view: { project_type_id: @project_view.project_type_id }
    assert_redirected_to project_view_path(assigns(:project_view))
  end

  test "should destroy project_view" do
    assert_difference('ProjectView.count', -1) do
      delete :destroy, id: @project_view
    end

    assert_redirected_to project_views_path
  end
end
