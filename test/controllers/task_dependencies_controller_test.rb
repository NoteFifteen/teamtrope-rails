require 'test_helper'

class TaskDependenciesControllerTest < ActionController::TestCase
  setup do
    @task_dependency = task_dependencies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:task_dependencies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task_dependency" do
    assert_difference('TaskDependency.count') do
      post :create, task_dependency: { dependent_task_id: @task_dependency.dependent_task_id, main_task_id: @task_dependency.main_task_id }
    end

    assert_redirected_to task_dependency_path(assigns(:task_dependency))
  end

  test "should show task_dependency" do
    get :show, id: @task_dependency
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task_dependency
    assert_response :success
  end

  test "should update task_dependency" do
    patch :update, id: @task_dependency, task_dependency: { dependent_task_id: @task_dependency.dependent_task_id, main_task_id: @task_dependency.main_task_id }
    assert_redirected_to task_dependency_path(assigns(:task_dependency))
  end

  test "should destroy task_dependency" do
    assert_difference('TaskDependency.count', -1) do
      delete :destroy, id: @task_dependency
    end

    assert_redirected_to task_dependencies_path
  end
end
