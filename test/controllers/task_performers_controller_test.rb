require 'test_helper'

class TaskPerformersControllerTest < ActionController::TestCase
  setup do
    @task_performer = task_performers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:task_performers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task_performer" do
    assert_difference('TaskPerformer.count') do
      post :create, task_performer: {  }
    end

    assert_redirected_to task_performer_path(assigns(:task_performer))
  end

  test "should show task_performer" do
    get :show, id: @task_performer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task_performer
    assert_response :success
  end

  test "should update task_performer" do
    patch :update, id: @task_performer, task_performer: {  }
    assert_redirected_to task_performer_path(assigns(:task_performer))
  end

  test "should destroy task_performer" do
    assert_difference('TaskPerformer.count', -1) do
      delete :destroy, id: @task_performer
    end

    assert_redirected_to task_performers_path
  end
end
