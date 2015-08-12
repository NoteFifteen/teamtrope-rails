require 'test_helper'

class MediaKitsControllerTest < ActionController::TestCase
  setup do
    @media_kit = media_kits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_kits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create media_kit" do
    assert_difference('MediaKit.count') do
      post :create, media_kit: {  }
    end

    assert_redirected_to media_kit_path(assigns(:media_kit))
  end

  test "should show media_kit" do
    get :show, id: @media_kit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @media_kit
    assert_response :success
  end

  test "should update media_kit" do
    patch :update, id: @media_kit, media_kit: {  }
    assert_redirected_to media_kit_path(assigns(:media_kit))
  end

  test "should destroy media_kit" do
    assert_difference('MediaKit.count', -1) do
      delete :destroy, id: @media_kit
    end

    assert_redirected_to media_kits_path
  end
end
