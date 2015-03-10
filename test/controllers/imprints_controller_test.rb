require 'test_helper'

class ImprintsControllerTest < ActionController::TestCase
  setup do
    @imprint = imprints(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:imprints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create imprint" do
    assert_difference('Imprint.count') do
      post :create, imprint: { name: @imprint.name }
    end

    assert_redirected_to imprint_path(assigns(:imprint))
  end

  test "should show imprint" do
    get :show, id: @imprint
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @imprint
    assert_response :success
  end

  test "should update imprint" do
    patch :update, id: @imprint, imprint: { name: @imprint.name }
    assert_redirected_to imprint_path(assigns(:imprint))
  end

  test "should destroy imprint" do
    assert_difference('Imprint.count', -1) do
      delete :destroy, id: @imprint
    end

    assert_redirected_to imprints_path
  end
end
