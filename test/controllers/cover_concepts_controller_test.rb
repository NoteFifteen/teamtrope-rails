require 'test_helper'

class CoverConceptsControllerTest < ActionController::TestCase
  setup do
    @cover_concept = cover_concepts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cover_concepts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cover_concept" do
    assert_difference('CoverConcept.count') do
      post :create, cover_concept: {  }
    end

    assert_redirected_to cover_concept_path(assigns(:cover_concept))
  end

  test "should show cover_concept" do
    get :show, id: @cover_concept
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cover_concept
    assert_response :success
  end

  test "should update cover_concept" do
    patch :update, id: @cover_concept, cover_concept: {  }
    assert_redirected_to cover_concept_path(assigns(:cover_concept))
  end

  test "should destroy cover_concept" do
    assert_difference('CoverConcept.count', -1) do
      delete :destroy, id: @cover_concept
    end

    assert_redirected_to cover_concepts_path
  end
end
