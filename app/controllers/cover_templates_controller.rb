class CoverTemplatesController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :create
  before_action :set_cover_template, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /cover_templates
  # GET /cover_templates.json
  def index
    @cover_templates = CoverTemplate.all
  end

  # GET /cover_templates/1
  # GET /cover_templates/1.json
  def show
  end

  # GET /cover_templates/new
  def new
    @cover_template = CoverTemplate.new
  end

  # GET /cover_templates/1/edit
  def edit
  end

  def create
    @project = Project.friendly.find(params[:project_id])

    @cover_template = CoverTemplate.find_or_initialize_by(project_id: @project.id)
    @updated_file = nil
    update_hash = {}

    unless params[:cover_template_ebook_front_cover].nil?
      update_hash[:ebook_front_cover_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:ebook_front_cover_content_type] = (params[:filetype].nil?)? 'image/jpeg' : params[:filetype]
      update_hash[:ebook_front_cover_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:ebook_front_cover_direct_upload_url] = params[:cover_template_ebook_front_cover]['direct_upload_url'] unless params[:cover_template_ebook_front_cover]['direct_upload_url'].nil?
      @updated_file = "ebook_front_cover"
    end

    unless params[:cover_template_createspace_cover].nil?
      update_hash[:createspace_cover_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:createspace_cover_content_type] = params[:filename].nil?? 'application/pdf' : params[:filetype]
      update_hash[:createspace_cover_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:createspace_cover_direct_upload_url] = params[:cover_template_createspace_cover]['direct_upload_url'] unless params[:cover_template_createspace_cover]['direct_upload_url'].nil?
      @updated_file = "createspace_cover"
    end

    unless params[:cover_template_lightning_source_cover].nil?
      update_hash[:lightning_source_cover_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:lightning_source_cover_content_type] = params[:filename].nil?? 'application/pdf' : params[:filetype]
      update_hash[:lightning_source_cover_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:lightning_source_cover_direct_upload_url] = params[:cover_template_lightning_source_cover]['direct_upload_url'] unless params[:cover_template_lightning_source_cover]['direct_upload_url'].nil?
      @updated_file = "lightning_source_cover"
    end

    unless params[:cover_template_alternative_cover].nil?
      update_hash[:alternative_cover_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:alternative_cover_content_type] = params[:filename].nil?? 'application/pdf' : params[:filetype]
      update_hash[:alternative_cover_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:alternative_cover_direct_upload_url] = params[:cover_template_alternative_cover]['direct_upload_url'] unless params[:cover_template_alternative_cover]['direct_upload_url'].nil?
      @updated_file = "alternative_cover"
    end

    @cover_template.update(update_hash)
    @cover_template.save
    @last_errors = @cover_tempate.try(:errors).try(:full_messages)
    return
  end

  # PATCH/PUT /cover_templates/1
  # PATCH/PUT /cover_templates/1.json
  def update

    activity_text = nil
    updated = []
    should_send_email = false

    # setting the update text.
    [ {key: :updated_ebook_front_cover,      tag: 'eBook'},
      {key: :updated_createspace_cover,      tag: 'Createspace'},
      {key: :updated_lightning_source_cover, tag: 'Lightning Source'},
      {key: :updated_alternative_cover,      tag: 'Alternative'}
    ].each do | item |
      if !params[item[:key]].nil? && params[item[:key]] == 'yes'
        updated.push item[:tag]
      end
    end

    activity_text = "Edited the following covers: #{activity_text} #{updated.join(', ')}" if updated.size > 0

    unless activity_text.nil?
      @project.create_activity :edited_cover_templates, owner: current_user,
                              parameters: { text: activity_text, object_id: @cover_template.id, form_data: ''}

      ProjectMailer.upload_cover_templates(@project, current_user, params)
    end

    redirect_to @cover_template
  end

  # DELETE /cover_templates/1
  # DELETE /cover_templates/1.json
  def destroy
    @cover_tempate.destroy
    respond_to do |format|
      format.html { redirect_to cover_tempates_url, notice: 'Cover template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_cover_template
      @cover_template = CoverTemplate.find(params[:id])
    end

    def set_project
      @project = @cover_template.project
    end
end
