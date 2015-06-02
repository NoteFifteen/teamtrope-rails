class ProjectLayoutsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  before_action :set_project_layout, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @project_layouts = Layout.all
  end

  def show
  end

  def new
    @project_layout = Layout.new
  end

  def edit
  end

  def create
    @project = Project.friendly.find(params[:project_id])

    @layout = Layout.find_or_initialize_by(project_id: @project.id)
    @uploaded_file = nil
    update_hash = {}

    unless params[:layout_layout_upload].nil?
      update_hash[:layout_upload_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:layout_upload_content_type] = params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:layout_upload_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:layout_upload_direct_upload_url] = params[:layout_layout_upload]['direct_upload_url'] unless params[:layout_layout_upload]['direct_upload_url'].nil?
      @uploaded_file = "layout_upload"
    end
    @layout.update(update_hash)
    @layout.save
    @last_errors = @layout.try(:errors).try(:full_messages)
    return
  end

  def update
    respond_to do |format|
      if @project_layout.update(cover_tempate_params)
        format.html { redirect_to @project_layout, notice: 'Project layout was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_layout }
      else
        format.html { render :edit }
        format.json { render json: @project_layout.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_layout.destroy
    respond_to do |format|
      format.html { redirect_to project_layouts_url, notice: 'Project layout was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_project_layout
      @project_layout = Layout.find(params[:id])
    end

    def project_layout_params
      params.require(:project_layout).permit(:project_id, :exact_name_on_copyright, :final_page_count, :layout_approval_issue_list, :layout_approved, :layout_approved_date, :layout_notes, :page_header_display_name, :pen_name, :user_pen_name_for_copyright, :use_pen_name_on_title)
    end
end
