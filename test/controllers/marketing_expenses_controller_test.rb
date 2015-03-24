require 'test_helper'

class MarketingExpensesControllerTest < ActionController::TestCase
  setup do
    @marketing_expense = marketing_expenses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:marketing_expenses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create marketing_expense" do
    assert_difference('MarketingExpense.count') do
      post :create, marketing_expense: { cost: @marketing_expense.cost, end_date: @marketing_expense.end_date, invoice_due_date: @marketing_expense.invoice_due_date, other_information: @marketing_expense.other_information, project_id: @marketing_expense.project_id, service_provider_mask: @marketing_expense.service_provider_mask, start_date: @marketing_expense.start_date, type_mask: @marketing_expense.type_mask }
    end

    assert_redirected_to marketing_expense_path(assigns(:marketing_expense))
  end

  test "should show marketing_expense" do
    get :show, id: @marketing_expense
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @marketing_expense
    assert_response :success
  end

  test "should update marketing_expense" do
    patch :update, id: @marketing_expense, marketing_expense: { cost: @marketing_expense.cost, end_date: @marketing_expense.end_date, invoice_due_date: @marketing_expense.invoice_due_date, other_information: @marketing_expense.other_information, project_id: @marketing_expense.project_id, service_provider_mask: @marketing_expense.service_provider_mask, start_date: @marketing_expense.start_date, type_mask: @marketing_expense.type_mask }
    assert_redirected_to marketing_expense_path(assigns(:marketing_expense))
  end

  test "should destroy marketing_expense" do
    assert_difference('MarketingExpense.count', -1) do
      delete :destroy, id: @marketing_expense
    end

    assert_redirected_to marketing_expenses_path
  end
end
