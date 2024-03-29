class ManuscriptsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: [:create, :show]
  before_action :set_manuscript, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @manuscripts = Manuscript.all
  end

  def show
  end

  # This controller method is hit remotely via AJAX from a Project view.
  def create
    @project = Project.friendly.find(params[:project_id])

    # All examples (and code, really) seem to prefer a controller per file, whereas the CoverConcept model
    # is for a single set of two image files, so we have to do some janky stuff here to make it work.
    @manuscript = Manuscript.find_or_initialize_by(project_id: @project.id)
    @updated_file = nil
    update_hash = {}

    if ! params[:original_manuscript].nil?
      update_hash[:original_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:original_content_type] = params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:original_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:original_file_direct_upload_url] = params[:original_manuscript]['direct_upload_url'] unless params[:original_manuscript]['direct_upload_url'].nil?
      update_hash[:original_file_processed] = false
      @updated_file = 'original_manuscript'
    end

    if ! params[:edited_manuscript].nil?
      update_hash[:edited_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:edited_content_type] = params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:edited_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:edited_file_direct_upload_url] = params[:edited_manuscript]['direct_upload_url'] unless params[:edited_manuscript]['direct_upload_url'].nil?
      update_hash[:edited_file_processed] = false
      @updated_file = 'edited_manuscript'
    end

    if ! params[:proofread_reviewed_manuscript].nil?
      update_hash[:proofread_reviewed_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:proofread_reviewed_content_type] = params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:proofread_reviewed_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:proofread_reviewed_file_direct_upload_url] = params[:proofread_reviewed_manuscript]['direct_upload_url'] unless params[:proofread_reviewed_manuscript]['direct_upload_url'].nil?
      update_hash[:proofread_reviewed_file_processed] = false
      @updated_file = 'proofread_reviewed_manuscript'
    end

    if ! params[:proofread_final_manuscript].nil?
      update_hash[:proofread_final_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:proofread_final_content_type] = params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:proofread_final_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:proofread_final_file_direct_upload_url] = params[:proofread_final_manuscript]['direct_upload_url'] unless params[:proofread_final_manuscript]['direct_upload_url'].nil?
      update_hash[:proofread_final_file_processed] = false
      @updated_file = 'proofread_final_manuscript'
    end

    @manuscript.update(update_hash)
    @manuscript.save
    @last_errors = @manuscript.errors.full_messages
    return
  end

  def update
    activity_text = nil
    updated = []
    upload_mask = 0 # mask for determining which file was updated and requires a notification email.
    # setting the update text.
    [ {key: :updated_original_manuscript,           tag: 'Original'},
      {key: :updated_edited_manuscript,             tag: 'Edited'},
      {key: :updated_proofread_reviewed_manuscript, tag: 'Proofread Reviewed'},
      {key: :updated_proofread_final_manuscript,    tag: 'Final Proof'},
    ].each_with_index do | item, index |
      if !params[item[:key]].nil? && params[item[:key]] == 'yes'
        updated.push item[:tag]
        upload_mask |= 2**index
      end
    end

    activity_text = "Uploaded a new version of: #{activity_text} #{updated.join(', ')} for " if updated.size > 0

    unless activity_text.nil?
      @project.create_activity :edited_manuscripts, owner: current_user,
                             parameters: { text: activity_text, object_id: @manuscript.id, form_data: ''}
    end

    # sending alert emails based on the upload mask
    ProjectMailer.original_manuscript_uploaded(@project, current_user)         if upload_mask & 1 == 1
    ProjectMailer.submit_edited_manuscript(@project, current_user)             if upload_mask & 2 == 2
    ProjectMailer.submit_proofread_reviewed_manuscript(@project, current_user) if upload_mask & 4 == 4
    ProjectMailer.proofread_final_manuscript(@project, current_user, params)   if upload_mask & 8 == 8

    redirect_to @manuscript
  end

  private
    def set_manuscript
      @manuscript = Manuscript.find(params[:id])
    end

    def set_project
      @project = Manuscript.find(params[:id]).project
    end

end
