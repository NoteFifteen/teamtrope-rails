require 'test_helper'

class ApproveBlurbsControllerTest < ActionController::TestCase
  setup do
    @approve_blurb = approve_blurbs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:approve_blurbs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create approve_blurb" do
    assert_difference('ApproveBlurb.count') do
      post :create, approve_blurb: { blurb_approval_date: @approve_blurb.blurb_approval_date, blurb_approval_decision: @approve_blurb.blurb_approval_decision, blurb_notes: @approve_blurb.blurb_notes, project_id: @approve_blurb.project_id }
    end

    assert_redirected_to approve_blurb_path(assigns(:approve_blurb))
  end

  test "should show approve_blurb" do
    get :show, id: @approve_blurb
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @approve_blurb
    assert_response :success
  end

  test "should update approve_blurb" do
    patch :update, id: @approve_blurb, approve_blurb: { blurb_approval_date: @approve_blurb.blurb_approval_date, blurb_approval_decision: @approve_blurb.blurb_approval_decision, blurb_notes: @approve_blurb.blurb_notes, project_id: @approve_blurb.project_id }
    assert_redirected_to approve_blurb_path(assigns(:approve_blurb))
  end

  test "should destroy approve_blurb" do
    assert_difference('ApproveBlurb.count', -1) do
      delete :destroy, id: @approve_blurb
    end

    assert_redirected_to approve_blurbs_path
  end
end
