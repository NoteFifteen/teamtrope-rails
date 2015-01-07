class CurrentStepsController < ApplicationController
  before_action :set_current_step, only: [:show, :edit, :update, :destroy]

  # GET /current_steps
  # GET /current_steps.json
  def index
    @current_steps = CurrentStep.all
  end

  # GET /current_steps/1
  # GET /current_steps/1.json
  def show
  end

  # GET /current_steps/new
  def new
    @current_step = CurrentStep.new
  end

  # GET /current_steps/1/edit
  def edit
  end

  # POST /current_steps
  # POST /current_steps.json
  def create
    @current_step = CurrentStep.new(current_step_params)

    respond_to do |format|
      if @current_step.save
        format.html { redirect_to @current_step, notice: 'Current step was successfully created.' }
        format.json { render :show, status: :created, location: @current_step }
      else
        format.html { render :new }
        format.json { render json: @current_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /current_steps/1
  # PATCH/PUT /current_steps/1.json
  def update
    respond_to do |format|
      if @current_step.update(current_step_params)
        format.html { redirect_to @current_step, notice: 'Current step was successfully updated.' }
        format.json { render :show, status: :ok, location: @current_step }
      else
        format.html { render :edit }
        format.json { render json: @current_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /current_steps/1
  # DELETE /current_steps/1.json
  def destroy
    @current_step.destroy
    respond_to do |format|
      format.html { redirect_to current_steps_url, notice: 'Current step was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_current_step
      @current_step = CurrentStep.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def current_step_params
      params.require(:current_step).permit(:project_id, :workflow_step_id)
    end
end
