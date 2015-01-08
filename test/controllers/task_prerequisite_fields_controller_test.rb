require 'test_helper'

class TaskPrerequisiteFieldsControllerTest < ActionController::TestCase
  setup do
    @task_prerequisite_field = task_prerequisite_fields(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:task_prerequisite_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task_prerequisite_field" do
    assert_difference('TaskPrerequisiteField.count') do
      post :create, task_prerequisite_field: { field_name: @task_prerequisite_field.field_name, task_id: @task_prerequisite_field.task_id }
    end

    assert_redirected_to task_prerequisite_field_path(assigns(:task_prerequisite_field))
  end

  test "should show task_prerequisite_field" do
    get :show, id: @task_prerequisite_field
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task_prerequisite_field
    assert_response :success
  end

  test "should update task_prerequisite_field" do
    patch :update, id: @task_prerequisite_field, task_prerequisite_field: { field_name: @task_prerequisite_field.field_name, task_id: @task_prerequisite_field.task_id }
    assert_redirected_to task_prerequisite_field_path(assigns(:task_prerequisite_field))
  end

  test "should destroy task_prerequisite_field" do
    assert_difference('TaskPrerequisiteField.count', -1) do
      delete :destroy, id: @task_prerequisite_field
    end

    assert_redirected_to task_prerequisite_fields_path
  end
end
