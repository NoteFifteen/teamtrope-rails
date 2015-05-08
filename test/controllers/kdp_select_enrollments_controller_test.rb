require 'test_helper'

class KdpSelectEnrollmentsControllerTest < ActionController::TestCase
  setup do
    @kdp_select_enrollment = kdp_select_enrollments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kdp_select_enrollments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create kdp_select_enrollment" do
    assert_difference('KdpSelectEnrollment.count') do
      post :create, kdp_select_enrollment: { enrollment_date: @kdp_select_enrollment.enrollment_date, member_id: @kdp_select_enrollment.member_id, project_id: @kdp_select_enrollment.project_id, update_data: @kdp_select_enrollment.update_data, update_type: @kdp_select_enrollment.update_type }
    end

    assert_redirected_to kdp_select_enrollment_path(assigns(:kdp_select_enrollment))
  end

  test "should show kdp_select_enrollment" do
    get :show, id: @kdp_select_enrollment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @kdp_select_enrollment
    assert_response :success
  end

  test "should update kdp_select_enrollment" do
    patch :update, id: @kdp_select_enrollment, kdp_select_enrollment: { enrollment_date: @kdp_select_enrollment.enrollment_date, member_id: @kdp_select_enrollment.member_id, project_id: @kdp_select_enrollment.project_id, update_data: @kdp_select_enrollment.update_data, update_type: @kdp_select_enrollment.update_type }
    assert_redirected_to kdp_select_enrollment_path(assigns(:kdp_select_enrollment))
  end

  test "should destroy kdp_select_enrollment" do
    assert_difference('KdpSelectEnrollment.count', -1) do
      delete :destroy, id: @kdp_select_enrollment
    end

    assert_redirected_to kdp_select_enrollments_path
  end
end
