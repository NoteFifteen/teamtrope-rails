require 'test_helper'

class BookbubSubmissionsControllerTest < ActionController::TestCase
  setup do
    @bookbub_submission = bookbub_submissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bookbub_submissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bookbub_submission" do
    assert_difference('BookbubSubmission.count') do
      post :create, bookbub_submission: { asin: @bookbub_submission.asin, asin_linked_url: @bookbub_submission.asin_linked_url, author: @bookbub_submission.author, avg_rating: @bookbub_submission.avg_rating, current_price: @bookbub_submission.current_price, num_pages: @bookbub_submission.num_pages, num_reviews: @bookbub_submission.num_reviews, num_stars: @bookbub_submission.num_stars, project_id: @bookbub_submission.project_id, submitted_by_id: @bookbub_submission.submitted_by_id, title: @bookbub_submission.title }
    end

    assert_redirected_to bookbub_submission_path(assigns(:bookbub_submission))
  end

  test "should show bookbub_submission" do
    get :show, id: @bookbub_submission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bookbub_submission
    assert_response :success
  end

  test "should update bookbub_submission" do
    patch :update, id: @bookbub_submission, bookbub_submission: { asin: @bookbub_submission.asin, asin_linked_url: @bookbub_submission.asin_linked_url, author: @bookbub_submission.author, avg_rating: @bookbub_submission.avg_rating, current_price: @bookbub_submission.current_price, num_pages: @bookbub_submission.num_pages, num_reviews: @bookbub_submission.num_reviews, num_stars: @bookbub_submission.num_stars, project_id: @bookbub_submission.project_id, submitted_by_id: @bookbub_submission.submitted_by_id, title: @bookbub_submission.title }
    assert_redirected_to bookbub_submission_path(assigns(:bookbub_submission))
  end

  test "should destroy bookbub_submission" do
    assert_difference('BookbubSubmission.count', -1) do
      delete :destroy, id: @bookbub_submission
    end

    assert_redirected_to bookbub_submissions_path
  end
end
