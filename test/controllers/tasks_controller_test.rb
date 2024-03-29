require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, task: { days_to_complete: @task.days_to_complete, icon: @task.icon, intro_video: @task.intro_video, name: @task.name, next_id: @task.next_id, rejected_step_id: @task.rejected_step_id, tab_text: @task.tab_text, partial: @task.partial, workflow_id: @task.workflow_id }
    end

    assert_redirected_to task_path(assigns(:task))
  end

  test "should show task" do
    get :show, id: @task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task
    assert_response :success
  end

  test "should update task" do
    patch :update, id: @task, task: { days_to_complete: @task.days_to_complete, icon: @task.icon, intro_video: @task.intro_video, name: @task.name, next_id: @task.next_id, rejected_step_id: @task.rejected_step_id, tab_text: @task.tab_text, partial: @task.partial, workflow_id: @task.workflow_id }
    assert_redirected_to task_path(assigns(:task))
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task
    end

    assert_redirected_to tasks_path
  end
end
