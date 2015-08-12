require 'test_helper'

class ArtworkRightsRequestsControllerTest < ActionController::TestCase
  setup do
    @artwork_rights_request = artwork_rights_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:artwork_rights_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create artwork_rights_request" do
    assert_difference('ArtworkRightsRequest.count') do
      post :create, artwork_rights_request: { email: @artwork_rights_request.email, full_name: @artwork_rights_request.full_name, role_type: @artwork_rights_request.role_type }
    end

    assert_redirected_to artwork_rights_request_path(assigns(:artwork_rights_request))
  end

  test "should show artwork_rights_request" do
    get :show, id: @artwork_rights_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @artwork_rights_request
    assert_response :success
  end

  test "should update artwork_rights_request" do
    patch :update, id: @artwork_rights_request, artwork_rights_request: { email: @artwork_rights_request.email, full_name: @artwork_rights_request.full_name, role_type: @artwork_rights_request.role_type }
    assert_redirected_to artwork_rights_request_path(assigns(:artwork_rights_request))
  end

  test "should destroy artwork_rights_request" do
    assert_difference('ArtworkRightsRequest.count', -1) do
      delete :destroy, id: @artwork_rights_request
    end

    assert_redirected_to artwork_rights_requests_path
  end
end
