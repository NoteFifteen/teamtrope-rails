require 'test_helper'

class HellosignDocumentTypesControllerTest < ActionController::TestCase
  setup do
    @hellosign_document_type = hellosign_document_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hellosign_document_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hellosign_document_type" do
    assert_difference('HellosignDocumentType.count') do
      post :create, hellosign_document_type: { ccs: @hellosign_document_type.ccs, message: @hellosign_document_type.message, name: @hellosign_document_type.name, signers: @hellosign_document_type.signers, subject: @hellosign_document_type.subject, template_id: @hellosign_document_type.template_id }
    end

    assert_redirected_to hellosign_document_type_path(assigns(:hellosign_document_type))
  end

  test "should show hellosign_document_type" do
    get :show, id: @hellosign_document_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hellosign_document_type
    assert_response :success
  end

  test "should update hellosign_document_type" do
    patch :update, id: @hellosign_document_type, hellosign_document_type: { ccs: @hellosign_document_type.ccs, message: @hellosign_document_type.message, name: @hellosign_document_type.name, signers: @hellosign_document_type.signers, subject: @hellosign_document_type.subject, template_id: @hellosign_document_type.template_id }
    assert_redirected_to hellosign_document_type_path(assigns(:hellosign_document_type))
  end

  test "should destroy hellosign_document_type" do
    assert_difference('HellosignDocumentType.count', -1) do
      delete :destroy, id: @hellosign_document_type
    end

    assert_redirected_to hellosign_document_types_path
  end
end
