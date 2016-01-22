require 'test_helper'

class PrefunkEnrollmentsControllerTest < ActionController::TestCase
  setup do
    @prefunk_enrollment = prefunk_enrollments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prefunk_enrollments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prefunk_enrollment" do
    assert_difference('PrefunkEnrollment.count') do
      post :create, prefunk_enrollment: { project_id: @prefunk_enrollment.project_id, user_id: @prefunk_enrollment.user_id }
    end

    assert_redirected_to prefunk_enrollment_path(assigns(:prefunk_enrollment))
  end

  test "should show prefunk_enrollment" do
    get :show, id: @prefunk_enrollment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prefunk_enrollment
    assert_response :success
  end

  test "should update prefunk_enrollment" do
    patch :update, id: @prefunk_enrollment, prefunk_enrollment: { project_id: @prefunk_enrollment.project_id, user_id: @prefunk_enrollment.user_id }
    assert_redirected_to prefunk_enrollment_path(assigns(:prefunk_enrollment))
  end

  test "should destroy prefunk_enrollment" do
    assert_difference('PrefunkEnrollment.count', -1) do
      delete :destroy, id: @prefunk_enrollment
    end

    assert_redirected_to prefunk_enrollments_path
  end
end
