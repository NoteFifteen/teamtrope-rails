require 'test_helper'

class HellosignDocumentsControllerTest < ActionController::TestCase
  setup do
    @hellosign_document = hellosign_documents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hellosign_documents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hellosign_document" do
    assert_difference('HellosignDocument.count') do
      post :create, hellosign_document: { hellosign_id: @hellosign_document.hellosign_id, hellosignable_id: @hellosign_document.hellosignable_id, status: @hellosign_document.status }
    end

    assert_redirected_to hellosign_document_path(assigns(:hellosign_document))
  end

  test "should show hellosign_document" do
    get :show, id: @hellosign_document
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hellosign_document
    assert_response :success
  end

  test "should update hellosign_document" do
    patch :update, id: @hellosign_document, hellosign_document: { hellosign_id: @hellosign_document.hellosign_id, hellosignable_id: @hellosign_document.hellosignable_id, status: @hellosign_document.status }
    assert_redirected_to hellosign_document_path(assigns(:hellosign_document))
  end

  test "should destroy hellosign_document" do
    assert_difference('HellosignDocument.count', -1) do
      delete :destroy, id: @hellosign_document
    end

    assert_redirected_to hellosign_documents_path
  end
end
