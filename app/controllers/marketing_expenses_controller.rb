class MarketingExpensesController < ApplicationController
  before_action :set_marketing_expense, only: [:show, :edit, :update, :destroy]

  # GET /marketing_expenses
  # GET /marketing_expenses.json
  def index
    @marketing_expenses = MarketingExpense.all
  end

  # GET /marketing_expenses/1
  # GET /marketing_expenses/1.json
  def show
  end

  # GET /marketing_expenses/new
  def new
    @marketing_expense = MarketingExpense.new
  end

  # GET /marketing_expenses/1/edit
  def edit
  end

  # POST /marketing_expenses
  # POST /marketing_expenses.json
  def create
    @marketing_expense = MarketingExpense.new(marketing_expense_params)

    respond_to do |format|
      if @marketing_expense.save
        format.html { redirect_to @marketing_expense, notice: 'Marketing expense was successfully created.' }
        format.json { render :show, status: :created, location: @marketing_expense }
      else
        format.html { render :new }
        format.json { render json: @marketing_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /marketing_expenses/1
  # PATCH/PUT /marketing_expenses/1.json
  def update
    respond_to do |format|
      if @marketing_expense.update(marketing_expense_params)
        format.html { redirect_to @marketing_expense, notice: 'Marketing expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @marketing_expense }
      else
        format.html { render :edit }
        format.json { render json: @marketing_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /marketing_expenses/1
  # DELETE /marketing_expenses/1.json
  def destroy
    @marketing_expense.destroy
    respond_to do |format|
      format.html { redirect_to marketing_expenses_url, notice: 'Marketing expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_marketing_expense
      @marketing_expense = MarketingExpense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def marketing_expense_params
      params.require(:marketing_expense).permit(:project_id, :invoice_due_date, :start_date, :end_date, :expense_type, :service_provider, :cost, :other_information)
    end
end
