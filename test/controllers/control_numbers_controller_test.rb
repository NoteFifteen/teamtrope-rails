require 'test_helper'

class ControlNumbersControllerTest < ActionController::TestCase
  setup do
    @control_number = control_numbers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:control_numbers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create control_number" do
    assert_difference('ControlNumber.count') do
      post :create, control_number: {  }
    end

    assert_redirected_to control_number_path(assigns(:control_number))
  end

  test "should show control_number" do
    get :show, id: @control_number
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @control_number
    assert_response :success
  end

  test "should update control_number" do
    patch :update, id: @control_number, control_number: {  }
    assert_redirected_to control_number_path(assigns(:control_number))
  end

  test "should destroy control_number" do
    assert_difference('ControlNumber.count', -1) do
      delete :destroy, id: @control_number
    end

    assert_redirected_to control_numbers_path
  end
end
