require 'test_helper'

class CoverTemplatesControllerTest < ActionController::TestCase
  setup do
    @cover_template = cover_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cover_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cover_template" do
    assert_difference('CoverTemplate.count') do
      post :create, cover_template: { alternative_cover: @cover_template.alternative_cover, createspace_cover: @cover_template.createspace_cover, ebook_front_cover: @cover_template.ebook_front_cover, lightning_source: @cover_template.lightning_source }
    end

    assert_redirected_to cover_template_path(assigns(:cover_template))
  end

  test "should show cover_template" do
    get :show, id: @cover_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cover_template
    assert_response :success
  end

  test "should update cover_template" do
    patch :update, id: @cover_template, cover_template: { alternative_cover: @cover_template.alternative_cover, createspace_cover: @cover_template.createspace_cover, ebook_front_cover: @cover_template.ebook_front_cover, lightning_source: @cover_template.lightning_source }
    assert_redirected_to cover_template_path(assigns(:cover_template))
  end

  test "should destroy cover_template" do
    assert_difference('CoverTemplate.count', -1) do
      delete :destroy, id: @cover_template
    end

    assert_redirected_to cover_templates_path
  end
end
