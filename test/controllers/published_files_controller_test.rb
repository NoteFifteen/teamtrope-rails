require 'test_helper'

class PublishedFilesControllerTest < ActionController::TestCase
  setup do
    @published_file = published_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:published_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create published_file" do
    assert_difference('PublishedFile.count') do
      post :create, published_file: {  }
    end

    assert_redirected_to published_file_path(assigns(:published_file))
  end

  test "should show published_file" do
    get :show, id: @published_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @published_file
    assert_response :success
  end

  test "should update published_file" do
    patch :update, id: @published_file, published_file: {  }
    assert_redirected_to published_file_path(assigns(:published_file))
  end

  test "should destroy published_file" do
    assert_difference('PublishedFile.count', -1) do
      delete :destroy, id: @published_file
    end

    assert_redirected_to published_files_path
  end
end
