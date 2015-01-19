require 'test_helper'

class ProjectTypeWorkflowsControllerTest < ActionController::TestCase
  setup do
    @project_type_workflow = project_type_workflows(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_type_workflows)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_type_workflow" do
    assert_difference('ProjectTypeWorkflow.count') do
      post :create, project_type_workflow: { project_type_id: @project_type_workflow.project_type_id, workflow_id: @project_type_workflow.workflow_id }
    end

    assert_redirected_to project_type_workflow_path(assigns(:project_type_workflow))
  end

  test "should show project_type_workflow" do
    get :show, id: @project_type_workflow
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_type_workflow
    assert_response :success
  end

  test "should update project_type_workflow" do
    patch :update, id: @project_type_workflow, project_type_workflow: { project_type_id: @project_type_workflow.project_type_id, workflow_id: @project_type_workflow.workflow_id }
    assert_redirected_to project_type_workflow_path(assigns(:project_type_workflow))
  end

  test "should destroy project_type_workflow" do
    assert_difference('ProjectTypeWorkflow.count', -1) do
      delete :destroy, id: @project_type_workflow
    end

    assert_redirected_to project_type_workflows_path
  end
end
