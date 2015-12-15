require 'test_helper'

class NetgalleySubmissionsControllerTest < ActionController::TestCase
  setup do
    @netgalley_submission = netgalley_submissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:netgalley_submissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create netgalley_submission" do
    assert_difference('NetgalleySubmission.count') do
      post :create, netgalley_submission: { author_name: @netgalley_submission.author_name, blurb: @netgalley_submission.blurb, category_one: @netgalley_submission.category_one, category_two: @netgalley_submission.category_two, isbn: @netgalley_submission.isbn, praise: @netgalley_submission.praise, project_id: @netgalley_submission.project_id, publication_date: @netgalley_submission.publication_date, retail_price: @netgalley_submission.retail_price, title: @netgalley_submission.title, website_one: @netgalley_submission.website_one, website_three: @netgalley_submission.website_three, website_two: @netgalley_submission.website_two }
    end

    assert_redirected_to netgalley_submission_path(assigns(:netgalley_submission))
  end

  test "should show netgalley_submission" do
    get :show, id: @netgalley_submission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @netgalley_submission
    assert_response :success
  end

  test "should update netgalley_submission" do
    patch :update, id: @netgalley_submission, netgalley_submission: { author_name: @netgalley_submission.author_name, blurb: @netgalley_submission.blurb, category_one: @netgalley_submission.category_one, category_two: @netgalley_submission.category_two, isbn: @netgalley_submission.isbn, praise: @netgalley_submission.praise, project_id: @netgalley_submission.project_id, publication_date: @netgalley_submission.publication_date, retail_price: @netgalley_submission.retail_price, title: @netgalley_submission.title, website_one: @netgalley_submission.website_one, website_three: @netgalley_submission.website_three, website_two: @netgalley_submission.website_two }
    assert_redirected_to netgalley_submission_path(assigns(:netgalley_submission))
  end

  test "should destroy netgalley_submission" do
    assert_difference('NetgalleySubmission.count', -1) do
      delete :destroy, id: @netgalley_submission
    end

    assert_redirected_to netgalley_submissions_path
  end
end
