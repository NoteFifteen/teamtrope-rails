require 'test_helper'

class RightsBackRequestsControllerTest < ActionController::TestCase
  setup do
    @rights_back_request = rights_back_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rights_back_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rights_back_request" do
    assert_difference('RightsBackRequest.count') do
      post :create, rights_back_request: { accepted_agreement: @rights_back_request.accepted_agreement, author: @rights_back_request.author, book_format: @rights_back_request.book_format, integer: @rights_back_request.integer, project_id: @rights_back_request.project_id, published: @rights_back_request.published, reason: @rights_back_request.reason, roles: @rights_back_request.roles, submitted_by_id: @rights_back_request.submitted_by_id, title: @rights_back_request.title }
    end

    assert_redirected_to rights_back_request_path(assigns(:rights_back_request))
  end

  test "should show rights_back_request" do
    get :show, id: @rights_back_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rights_back_request
    assert_response :success
  end

  test "should update rights_back_request" do
    patch :update, id: @rights_back_request, rights_back_request: { accepted_agreement: @rights_back_request.accepted_agreement, author: @rights_back_request.author, book_format: @rights_back_request.book_format, integer: @rights_back_request.integer, project_id: @rights_back_request.project_id, published: @rights_back_request.published, reason: @rights_back_request.reason, roles: @rights_back_request.roles, submitted_by_id: @rights_back_request.submitted_by_id, title: @rights_back_request.title }
    assert_redirected_to rights_back_request_path(assigns(:rights_back_request))
  end

  test "should destroy rights_back_request" do
    assert_difference('RightsBackRequest.count', -1) do
      delete :destroy, id: @rights_back_request
    end

    assert_redirected_to rights_back_requests_path
  end
end
