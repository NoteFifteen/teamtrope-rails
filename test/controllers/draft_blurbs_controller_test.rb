require 'test_helper'

class DraftBlurbsControllerTest < ActionController::TestCase
  setup do
    @draft_blurb = draft_blurbs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:draft_blurbs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create draft_blurb" do
    assert_difference('DraftBlurb.count') do
      post :create, draft_blurb: { draft_blurb: @draft_blurb.draft_blurb, project_id: @draft_blurb.project_id }
    end

    assert_redirected_to draft_blurb_path(assigns(:draft_blurb))
  end

  test "should show draft_blurb" do
    get :show, id: @draft_blurb
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @draft_blurb
    assert_response :success
  end

  test "should update draft_blurb" do
    patch :update, id: @draft_blurb, draft_blurb: { draft_blurb: @draft_blurb.draft_blurb, project_id: @draft_blurb.project_id }
    assert_redirected_to draft_blurb_path(assigns(:draft_blurb))
  end

  test "should destroy draft_blurb" do
    assert_difference('DraftBlurb.count', -1) do
      delete :destroy, id: @draft_blurb
    end

    assert_redirected_to draft_blurbs_path
  end
end
