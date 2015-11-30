require 'test_helper'

class ChannelReportsControllerTest < ActionController::TestCase
  setup do
    @channel_report = channel_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:channel_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create channel_report" do
    assert_difference('ChannelReport.count') do
      post :create, channel_report: { scan_date: @channel_report.scan_date }
    end

    assert_redirected_to channel_report_path(assigns(:channel_report))
  end

  test "should show channel_report" do
    get :show, id: @channel_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @channel_report
    assert_response :success
  end

  test "should update channel_report" do
    patch :update, id: @channel_report, channel_report: { scan_date: @channel_report.scan_date }
    assert_redirected_to channel_report_path(assigns(:channel_report))
  end

  test "should destroy channel_report" do
    assert_difference('ChannelReport.count', -1) do
      delete :destroy, id: @channel_report
    end

    assert_redirected_to channel_reports_path
  end
end
