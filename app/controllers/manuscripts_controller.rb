class ManuscriptsController < ApplicationController
  before_action :signed_in_user

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

    if ! params[:proofed_manuscript].nil?
      update_hash[:proofed_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:proofed_content_type] = params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:proofed_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:proofed_file_direct_upload_url] = params[:proofed_manuscript]['direct_upload_url'] unless params[:proofed_manuscript]['direct_upload_url'].nil?
      update_hash[:proofed_file_processed] = false
      @updated_file = 'proofed_manuscript'
    end

    @manuscript.update(update_hash)
    @manuscript.save
    @last_errors = @manuscript.errors.full_messages
    return
  end

end
