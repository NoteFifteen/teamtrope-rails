require 'test_helper'

class ImportedContractsControllerTest < ActionController::TestCase
  setup do
    @imported_contract = imported_contracts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:imported_contracts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create imported_contract" do
    assert_difference('ImportedContract.count') do
      post :create, imported_contract: { contract: @imported_contract.contract, document_date: @imported_contract.document_date, document_signers: @imported_contract.document_signers, document_type: @imported_contract.document_type }
    end

    assert_redirected_to imported_contract_path(assigns(:imported_contract))
  end

  test "should show imported_contract" do
    get :show, id: @imported_contract
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @imported_contract
    assert_response :success
  end

  test "should update imported_contract" do
    patch :update, id: @imported_contract, imported_contract: { contract: @imported_contract.contract, document_date: @imported_contract.document_date, document_signers: @imported_contract.document_signers, document_type: @imported_contract.document_type }
    assert_redirected_to imported_contract_path(assigns(:imported_contract))
  end

  test "should destroy imported_contract" do
    assert_difference('ImportedContract.count', -1) do
      delete :destroy, id: @imported_contract
    end

    assert_redirected_to imported_contracts_path
  end
end
