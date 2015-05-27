class ProductionExpensesController < ApplicationController
  before_action :set_production_expense, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @production_expenses = ProductionExpense.all
    respond_with(@production_expenses)
  end

  def show
    respond_with(@production_expense)
  end

  def new
    @production_expense = ProductionExpense.new
    respond_with(@production_expense)
  end

  def edit
  end

  def create
    @production_expense = ProductionExpense.new(production_expense_params)
    @production_expense.save
    respond_with(@production_expense)
  end

  def update
    @production_expense.update(production_expense_params)
    respond_with(@production_expense)
  end

  def destroy
    @production_expense.destroy
    respond_with(@production_expense)
  end

  private
    def set_production_expense
      @production_expense = ProductionExpense.find(params[:id])
    end

    def production_expense_params
      params.require(:production_expense).permit(:project_id, :total_quantity_ordered, :total_cost, :complimentary_quantity, :complimentary_cost, :author_advance_quantity, :author_advance_cost, :purchased_quantity, :purchased_cost, :paypal_invoice_amount, :calculation_explanation, :marketing_quantity, :additional_cost_mask, :additional_team_cost, :additional_booktrope_cost, :effective_date)
    end
end
