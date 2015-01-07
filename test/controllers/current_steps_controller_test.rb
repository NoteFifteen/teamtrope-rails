require 'test_helper'

class CurrentStepsControllerTest < ActionController::TestCase
  setup do
    @current_step = current_steps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:current_steps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create current_step" do
    assert_difference('CurrentStep.count') do
      post :create, current_step: { project_id: @current_step.project_id, workflow_step_id: @current_step.workflow_step_id }
    end

    assert_redirected_to current_step_path(assigns(:current_step))
  end

  test "should show current_step" do
    get :show, id: @current_step
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @current_step
    assert_response :success
  end

  test "should update current_step" do
    patch :update, id: @current_step, current_step: { project_id: @current_step.project_id, workflow_step_id: @current_step.workflow_step_id }
    assert_redirected_to current_step_path(assigns(:current_step))
  end

  test "should destroy current_step" do
    assert_difference('CurrentStep.count', -1) do
      delete :destroy, id: @current_step
    end

    assert_redirected_to current_steps_path
  end
end
