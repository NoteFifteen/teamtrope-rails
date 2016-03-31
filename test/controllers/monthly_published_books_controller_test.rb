require 'test_helper'

class MonthlyPublishedBooksControllerTest < ActionController::TestCase
  setup do
    @monthly_published_book = monthly_published_books(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:monthly_published_books)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create monthly_published_book" do
    assert_difference('MonthlyPublishedBook.count') do
      post :create, monthly_published_book: { published_books: @monthly_published_book.published_books, published_monthly: @monthly_published_book.published_monthly, published_total: @monthly_published_book.published_total, report_date: @monthly_published_book.report_date }
    end

    assert_redirected_to monthly_published_book_path(assigns(:monthly_published_book))
  end

  test "should show monthly_published_book" do
    get :show, id: @monthly_published_book
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @monthly_published_book
    assert_response :success
  end

  test "should update monthly_published_book" do
    patch :update, id: @monthly_published_book, monthly_published_book: { published_books: @monthly_published_book.published_books, published_monthly: @monthly_published_book.published_monthly, published_total: @monthly_published_book.published_total, report_date: @monthly_published_book.report_date }
    assert_redirected_to monthly_published_book_path(assigns(:monthly_published_book))
  end

  test "should destroy monthly_published_book" do
    assert_difference('MonthlyPublishedBook.count', -1) do
      delete :destroy, id: @monthly_published_book
    end

    assert_redirected_to monthly_published_books_path
  end
end
