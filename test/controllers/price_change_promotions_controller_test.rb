require 'test_helper'

class PriceChangePromotionsControllerTest < ActionController::TestCase
  setup do
    @price_change_promotion = price_change_promotions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:price_change_promotions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create price_change_promotion" do
    assert_difference('PriceChangePromotion.count') do
      post :create, price_change_promotion: { end_date: @price_change_promotion.end_date, price_after_promotion: @price_change_promotion.price_after_promotion, price_promotion: @price_change_promotion.price_promotion, project_id: @price_change_promotion.project_id, sites: @price_change_promotion.sites, start_date: @price_change_promotion.start_date, type_mask: @price_change_promotion.type_mask }
    end

    assert_redirected_to price_change_promotion_path(assigns(:price_change_promotion))
  end

  test "should show price_change_promotion" do
    get :show, id: @price_change_promotion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @price_change_promotion
    assert_response :success
  end

  test "should update price_change_promotion" do
    patch :update, id: @price_change_promotion, price_change_promotion: { end_date: @price_change_promotion.end_date, price_after_promotion: @price_change_promotion.price_after_promotion, price_promotion: @price_change_promotion.price_promotion, project_id: @price_change_promotion.project_id, sites: @price_change_promotion.sites, start_date: @price_change_promotion.start_date, type_mask: @price_change_promotion.type_mask }
    assert_redirected_to price_change_promotion_path(assigns(:price_change_promotion))
  end

  test "should destroy price_change_promotion" do
    assert_difference('PriceChangePromotion.count', -1) do
      delete :destroy, id: @price_change_promotion
    end

    assert_redirected_to price_change_promotions_path
  end
end
