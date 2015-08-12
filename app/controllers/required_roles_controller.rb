class RequiredRolesController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_required_role, only: [:show, :edit, :update, :destroy]

  # GET /required_roles
  # GET /required_roles.json
  def index
    @required_roles = RequiredRole.all
  end

  # GET /required_roles/1
  # GET /required_roles/1.json
  def show
  end

  # GET /required_roles/new
  def new
    @required_role = RequiredRole.new
  end

  # GET /required_roles/1/edit
  def edit
  end

  # POST /required_roles
  # POST /required_roles.json
  def create
    @required_role = RequiredRole.new(required_role_params)

    respond_to do |format|
      if @required_role.save
        format.html { redirect_to @required_role, notice: 'Required role was successfully created.' }
        format.json { render :show, status: :created, location: @required_role }
      else
        format.html { render :new }
        format.json { render json: @required_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /required_roles/1
  # PATCH/PUT /required_roles/1.json
  def update
    respond_to do |format|
      if @required_role.update(required_role_params)
        format.html { redirect_to @required_role, notice: 'Required role was successfully updated.' }
        format.json { render :show, status: :ok, location: @required_role }
      else
        format.html { render :edit }
        format.json { render json: @required_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /required_roles/1
  # DELETE /required_roles/1.json
  def destroy
    @required_role.destroy
    respond_to do |format|
      format.html { redirect_to required_roles_url, notice: 'Required role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_required_role
      @required_role = RequiredRole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def required_role_params
      params.require(:required_role).permit(:role_id, :project_type_id, :suggested_percent)
    end
end
