require 'test_helper'

class DocumentImportQueuesControllerTest < ActionController::TestCase
  setup do
    @document_import_queue = document_import_queues(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:document_import_queues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create document_import_queue" do
    assert_difference('DocumentImportQueue.count') do
      post :create, document_import_queue: { attachment_id: @document_import_queue.attachment_id, dyno_id: @document_import_queue.dyno_id, error: @document_import_queue.error, fieldname: @document_import_queue.fieldname, status: @document_import_queue.status, url: @document_import_queue.url, wp_id: @document_import_queue.wp_id }
    end

    assert_redirected_to document_import_queue_path(assigns(:document_import_queue))
  end

  test "should show document_import_queue" do
    get :show, id: @document_import_queue
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @document_import_queue
    assert_response :success
  end

  test "should update document_import_queue" do
    patch :update, id: @document_import_queue, document_import_queue: { attachment_id: @document_import_queue.attachment_id, dyno_id: @document_import_queue.dyno_id, error: @document_import_queue.error, fieldname: @document_import_queue.fieldname, status: @document_import_queue.status, url: @document_import_queue.url, wp_id: @document_import_queue.wp_id }
    assert_redirected_to document_import_queue_path(assigns(:document_import_queue))
  end

  test "should destroy document_import_queue" do
    assert_difference('DocumentImportQueue.count', -1) do
      delete :destroy, id: @document_import_queue
    end

    assert_redirected_to document_import_queues_path
  end
end
