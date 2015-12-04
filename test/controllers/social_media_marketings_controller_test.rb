require 'test_helper'

class SocialMediaMarketingsControllerTest < ActionController::TestCase
  setup do
    @social_media_marketing = social_media_marketings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:social_media_marketings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create social_media_marketing" do
    assert_difference('SocialMediaMarketing.count') do
      post :create, social_media_marketing: { author_central_account_link: @social_media_marketing.author_central_account_link, author_facebook_page: @social_media_marketing.author_facebook_page, goodreads: @social_media_marketing.goodreads, pintrest: @social_media_marketing.pintrest, project_id: @social_media_marketing.project_id, twitter: @social_media_marketing.twitter, website_url: @social_media_marketing.website_url }
    end

    assert_redirected_to social_media_marketing_path(assigns(:social_media_marketing))
  end

  test "should show social_media_marketing" do
    get :show, id: @social_media_marketing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @social_media_marketing
    assert_response :success
  end

  test "should update social_media_marketing" do
    patch :update, id: @social_media_marketing, social_media_marketing: { author_central_account_link: @social_media_marketing.author_central_account_link, author_facebook_page: @social_media_marketing.author_facebook_page, goodreads: @social_media_marketing.goodreads, pintrest: @social_media_marketing.pintrest, project_id: @social_media_marketing.project_id, twitter: @social_media_marketing.twitter, website_url: @social_media_marketing.website_url }
    assert_redirected_to social_media_marketing_path(assigns(:social_media_marketing))
  end

  test "should destroy social_media_marketing" do
    assert_difference('SocialMediaMarketing.count', -1) do
      delete :destroy, id: @social_media_marketing
    end

    assert_redirected_to social_media_marketings_path
  end
end
