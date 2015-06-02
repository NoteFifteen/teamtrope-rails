require 'test_helper'

class ProjectLayoutsControllerTest < ActionController::TestCase
  setup do
    @project_layout = project_layouts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_layouts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_layout" do
    assert_difference('ProjectLayout.count') do
      post :create, project_layout: { exact_name_on_copyright: @project_layout.exact_name_on_copyright, final_page_count: @project_layout.final_page_count, layout_approval_issue_list: @project_layout.layout_approval_issue_list, layout_approved: @project_layout.layout_approved, layout_approved_date: @project_layout.layout_approved_date, layout_notes: @project_layout.layout_notes, page_header_display_name: @project_layout.page_header_display_name, pen_name: @project_layout.pen_name, project_id: @project_layout.project_id, use_pen_name_on_title: @project_layout.use_pen_name_on_title, user_pen_name_for_copyright: @project_layout.user_pen_name_for_copyright }
    end

    assert_redirected_to project_layout_path(assigns(:project_layout))
  end

  test "should show project_layout" do
    get :show, id: @project_layout
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_layout
    assert_response :success
  end

  test "should update project_layout" do
    patch :update, id: @project_layout, project_layout: { exact_name_on_copyright: @project_layout.exact_name_on_copyright, final_page_count: @project_layout.final_page_count, layout_approval_issue_list: @project_layout.layout_approval_issue_list, layout_approved: @project_layout.layout_approved, layout_approved_date: @project_layout.layout_approved_date, layout_notes: @project_layout.layout_notes, page_header_display_name: @project_layout.page_header_display_name, pen_name: @project_layout.pen_name, project_id: @project_layout.project_id, use_pen_name_on_title: @project_layout.use_pen_name_on_title, user_pen_name_for_copyright: @project_layout.user_pen_name_for_copyright }
    assert_redirected_to project_layout_path(assigns(:project_layout))
  end

  test "should destroy project_layout" do
    assert_difference('ProjectLayout.count', -1) do
      delete :destroy, id: @project_layout
    end

    assert_redirected_to project_layouts_path
  end
end
