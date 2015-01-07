require 'test_helper'

class UnlockedTasksControllerTest < ActionController::TestCase
  setup do
    @unlocked_task = unlocked_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unlocked_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unlocked_task" do
    assert_difference('UnlockedTask.count') do
      post :create, unlocked_task: { unlocked_task_id: @unlocked_task.unlocked_task_id, workflowstep_id: @unlocked_task.workflowstep_id }
    end

    assert_redirected_to unlocked_task_path(assigns(:unlocked_task))
  end

  test "should show unlocked_task" do
    get :show, id: @unlocked_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @unlocked_task
    assert_response :success
  end

  test "should update unlocked_task" do
    patch :update, id: @unlocked_task, unlocked_task: { unlocked_task_id: @unlocked_task.unlocked_task_id, workflowstep_id: @unlocked_task.workflowstep_id }
    assert_redirected_to unlocked_task_path(assigns(:unlocked_task))
  end

  test "should destroy unlocked_task" do
    assert_difference('UnlockedTask.count', -1) do
      delete :destroy, id: @unlocked_task
    end

    assert_redirected_to unlocked_tasks_path
  end
end
