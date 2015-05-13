require 'test_helper'

class PrintCornersControllerTest < ActionController::TestCase
  setup do
    @print_corner = print_corners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:print_corners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create print_corner" do
    assert_difference('PrintCorner.count') do
      post :create, print_corner: { additional_order: @print_corner.additional_order, billing_acceptance: @print_corner.billing_acceptance, contact_phone: @print_corner.contact_phone, expedite_instructions: @print_corner.expedite_instructions, first_order: @print_corner.first_order, has_author_profile: @print_corner.has_author_profile, has_marketing_plan: @print_corner.has_marketing_plan, marketing_copy_message: @print_corner.marketing_copy_message, marketing_plan_link: @print_corner.marketing_plan_link, order_type: @print_corner.order_type, over_125: @print_corner.over_125, project_id: @print_corner.project_id, quantity: @print_corner.quantity, shipping_address_city: @print_corner.shipping_address_city, shipping_address_state: @print_corner.shipping_address_state, shipping_address_street_1: @print_corner.shipping_address_street_1, shipping_address_street_2: @print_corner.shipping_address_street_2, shipping_address_zip: @print_corner.shipping_address_zip, shipping_recipient: @print_corner.shipping_recipient, user_id: @print_corner.user_id }
    end

    assert_redirected_to print_corner_path(assigns(:print_corner))
  end

  test "should show print_corner" do
    get :show, id: @print_corner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @print_corner
    assert_response :success
  end

  test "should update print_corner" do
    patch :update, id: @print_corner, print_corner: { additional_order: @print_corner.additional_order, billing_acceptance: @print_corner.billing_acceptance, contact_phone: @print_corner.contact_phone, expedite_instructions: @print_corner.expedite_instructions, first_order: @print_corner.first_order, has_author_profile: @print_corner.has_author_profile, has_marketing_plan: @print_corner.has_marketing_plan, marketing_copy_message: @print_corner.marketing_copy_message, marketing_plan_link: @print_corner.marketing_plan_link, order_type: @print_corner.order_type, over_125: @print_corner.over_125, project_id: @print_corner.project_id, quantity: @print_corner.quantity, shipping_address_city: @print_corner.shipping_address_city, shipping_address_state: @print_corner.shipping_address_state, shipping_address_street_1: @print_corner.shipping_address_street_1, shipping_address_street_2: @print_corner.shipping_address_street_2, shipping_address_zip: @print_corner.shipping_address_zip, shipping_recipient: @print_corner.shipping_recipient, user_id: @print_corner.user_id }
    assert_redirected_to print_corner_path(assigns(:print_corner))
  end

  test "should destroy print_corner" do
    assert_difference('PrintCorner.count', -1) do
      delete :destroy, id: @print_corner
    end

    assert_redirected_to print_corners_path
  end
end
