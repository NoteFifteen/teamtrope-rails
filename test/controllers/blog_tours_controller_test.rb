require 'test_helper'

class BlogToursControllerTest < ActionController::TestCase
  setup do
    @blog_tour = blog_tours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blog_tours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blog_tour" do
    assert_difference('BlogTour.count') do
      post :create, blog_tour: { blog_tour_service: @blog_tour.blog_tour_service, cost: @blog_tour.cost, end_date: @blog_tour.end_date, number_of_stops: @blog_tour.number_of_stops, project_id: @blog_tour.project_id, start_date: @blog_tour.start_date, tour_type: @blog_tour.tour_type }
    end

    assert_redirected_to blog_tour_path(assigns(:blog_tour))
  end

  test "should show blog_tour" do
    get :show, id: @blog_tour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @blog_tour
    assert_response :success
  end

  test "should update blog_tour" do
    patch :update, id: @blog_tour, blog_tour: { blog_tour_service: @blog_tour.blog_tour_service, cost: @blog_tour.cost, end_date: @blog_tour.end_date, number_of_stops: @blog_tour.number_of_stops, project_id: @blog_tour.project_id, start_date: @blog_tour.start_date, tour_type: @blog_tour.tour_type }
    assert_redirected_to blog_tour_path(assigns(:blog_tour))
  end

  test "should destroy blog_tour" do
    assert_difference('BlogTour.count', -1) do
      delete :destroy, id: @blog_tour
    end

    assert_redirected_to blog_tours_path
  end
end
