require 'test_helper'

class EbookOnlyIncentivesControllerTest < ActionController::TestCase
  setup do
    @ebook_only_incentive = ebook_only_incentives(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ebook_only_incentives)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ebook_only_incentive" do
    assert_difference('EbookOnlyIncentive.count') do
      post :create, ebook_only_incentive: { author_name: @ebook_only_incentive.author_name, blurb: @ebook_only_incentive.blurb, category_one: @ebook_only_incentive.category_one, category_two: @ebook_only_incentive.category_two, isbn: @ebook_only_incentive.isbn, praise: @ebook_only_incentive.praise, project_id: @ebook_only_incentive.project_id, publication_date: @ebook_only_incentive.publication_date, retail_price: @ebook_only_incentive.retail_price, title: @ebook_only_incentive.title, website_one: @ebook_only_incentive.website_one, website_three: @ebook_only_incentive.website_three, website_two: @ebook_only_incentive.website_two }
    end

    assert_redirected_to ebook_only_incentive_path(assigns(:ebook_only_incentive))
  end

  test "should show ebook_only_incentive" do
    get :show, id: @ebook_only_incentive
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ebook_only_incentive
    assert_response :success
  end

  test "should update ebook_only_incentive" do
    patch :update, id: @ebook_only_incentive, ebook_only_incentive: { author_name: @ebook_only_incentive.author_name, blurb: @ebook_only_incentive.blurb, category_one: @ebook_only_incentive.category_one, category_two: @ebook_only_incentive.category_two, isbn: @ebook_only_incentive.isbn, praise: @ebook_only_incentive.praise, project_id: @ebook_only_incentive.project_id, publication_date: @ebook_only_incentive.publication_date, retail_price: @ebook_only_incentive.retail_price, title: @ebook_only_incentive.title, website_one: @ebook_only_incentive.website_one, website_three: @ebook_only_incentive.website_three, website_two: @ebook_only_incentive.website_two }
    assert_redirected_to ebook_only_incentive_path(assigns(:ebook_only_incentive))
  end

  test "should destroy ebook_only_incentive" do
    assert_difference('EbookOnlyIncentive.count', -1) do
      delete :destroy, id: @ebook_only_incentive
    end

    assert_redirected_to ebook_only_incentives_path
  end
end
