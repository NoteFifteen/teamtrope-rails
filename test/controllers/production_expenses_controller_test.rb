require 'test_helper'

class ProductionExpensesControllerTest < ActionController::TestCase
  setup do
    @production_expense = production_expenses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:production_expenses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create production_expense" do
    assert_difference('ProductionExpense.count') do
      post :create, production_expense: { additional_booktrope_cost: @production_expense.additional_booktrope_cost, additional_cost_mask: @production_expense.additional_cost_mask, additional_team_cost: @production_expense.additional_team_cost, author_advance_cost: @production_expense.author_advance_cost, author_advance_quantity: @production_expense.author_advance_quantity, calculation_explanation: @production_expense.calculation_explanation, complimentary_cost: @production_expense.complimentary_cost, complimentary_quantity: @production_expense.complimentary_quantity, effective_date: @production_expense.effective_date, marketing_quantity: @production_expense.marketing_quantity, paypal_invoice_amount: @production_expense.paypal_invoice_amount, project_id: @production_expense.project_id, purchased_cost: @production_expense.purchased_cost, purchased_quantity: @production_expense.purchased_quantity, total_cost: @production_expense.total_cost, total_quantity_ordered: @production_expense.total_quantity_ordered }
    end

    assert_redirected_to production_expense_path(assigns(:production_expense))
  end

  test "should show production_expense" do
    get :show, id: @production_expense
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @production_expense
    assert_response :success
  end

  test "should update production_expense" do
    patch :update, id: @production_expense, production_expense: { additional_booktrope_cost: @production_expense.additional_booktrope_cost, additional_cost_mask: @production_expense.additional_cost_mask, additional_team_cost: @production_expense.additional_team_cost, author_advance_cost: @production_expense.author_advance_cost, author_advance_quantity: @production_expense.author_advance_quantity, calculation_explanation: @production_expense.calculation_explanation, complimentary_cost: @production_expense.complimentary_cost, complimentary_quantity: @production_expense.complimentary_quantity, effective_date: @production_expense.effective_date, marketing_quantity: @production_expense.marketing_quantity, paypal_invoice_amount: @production_expense.paypal_invoice_amount, project_id: @production_expense.project_id, purchased_cost: @production_expense.purchased_cost, purchased_quantity: @production_expense.purchased_quantity, total_cost: @production_expense.total_cost, total_quantity_ordered: @production_expense.total_quantity_ordered }
    assert_redirected_to production_expense_path(assigns(:production_expense))
  end

  test "should destroy production_expense" do
    assert_difference('ProductionExpense.count', -1) do
      delete :destroy, id: @production_expense
    end

    assert_redirected_to production_expenses_path
  end
end
