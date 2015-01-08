require 'test_helper'

class CurrentTasksControllerTest < ActionController::TestCase
  setup do
    @current_task = current_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:current_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create current_task" do
    assert_difference('CurrentTask.count') do
      post :create, current_task: { project_id: @current_task.project_id, task_id: @current_task.task_id }
    end

    assert_redirected_to current_task_path(assigns(:current_task))
  end

  test "should show current_task" do
    get :show, id: @current_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @current_task
    assert_response :success
  end

  test "should update current_task" do
    patch :update, id: @current_task, current_task: { project_id: @current_task.project_id, task_id: @current_task.task_id }
    assert_redirected_to current_task_path(assigns(:current_task))
  end

  test "should destroy current_task" do
    assert_difference('CurrentTask.count', -1) do
      delete :destroy, id: @current_task
    end

    assert_redirected_to current_tasks_path
  end
end
