require 'test_helper'

class WorkflowTasksControllerTest < ActionController::TestCase
  setup do
    @workflow_task = workflow_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workflow_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create workflow_task" do
    assert_difference('WorkflowTask.count') do
      post :create, workflow_task: { next_task: @workflow_task.next_task, task_id: @workflow_task.task_id, workflow_id: @workflow_task.workflow_id }
    end

    assert_redirected_to workflow_task_path(assigns(:workflow_task))
  end

  test "should show workflow_task" do
    get :show, id: @workflow_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @workflow_task
    assert_response :success
  end

  test "should update workflow_task" do
    patch :update, id: @workflow_task, workflow_task: { next_task: @workflow_task.next_task, task_id: @workflow_task.task_id, workflow_id: @workflow_task.workflow_id }
    assert_redirected_to workflow_task_path(assigns(:workflow_task))
  end

  test "should destroy workflow_task" do
    assert_difference('WorkflowTask.count', -1) do
      delete :destroy, id: @workflow_task
    end

    assert_redirected_to workflow_tasks_path
  end
end
