require 'test_helper'

class ChannelReportItemsControllerTest < ActionController::TestCase
  setup do
    @channel_report_item = channel_report_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:channel_report_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create channel_report_item" do
    assert_difference('ChannelReportItem.count') do
      post :create, channel_report_item: { amazon: @channel_report_item.amazon, amazon_link: @channel_report_item.amazon_link, apple: @channel_report_item.apple, apple_link: @channel_report_item.apple_link, channel_report_id: @channel_report_item.channel_report_id, kdp_select: @channel_report_item.kdp_select, nook: @channel_report_item.nook, nook_link: @channel_report_item.nook_link, title: @channel_report_item.title }
    end

    assert_redirected_to channel_report_item_path(assigns(:channel_report_item))
  end

  test "should show channel_report_item" do
    get :show, id: @channel_report_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @channel_report_item
    assert_response :success
  end

  test "should update channel_report_item" do
    patch :update, id: @channel_report_item, channel_report_item: { amazon: @channel_report_item.amazon, amazon_link: @channel_report_item.amazon_link, apple: @channel_report_item.apple, apple_link: @channel_report_item.apple_link, channel_report_id: @channel_report_item.channel_report_id, kdp_select: @channel_report_item.kdp_select, nook: @channel_report_item.nook, nook_link: @channel_report_item.nook_link, title: @channel_report_item.title }
    assert_redirected_to channel_report_item_path(assigns(:channel_report_item))
  end

  test "should destroy channel_report_item" do
    assert_difference('ChannelReportItem.count', -1) do
      delete :destroy, id: @channel_report_item
    end

    assert_redirected_to channel_report_items_path
  end
end
