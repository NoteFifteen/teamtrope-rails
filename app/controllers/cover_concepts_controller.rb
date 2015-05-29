class CoverConceptsController < ApplicationController
  before_action :signed_in_user

  # This controller method is hit remotely via AJAX from a Project view.
  def create
    @project = Project.friendly.find(params[:project_id])

    # All examples (and code, really) seem to prefer a controller per file, whereas the CoverConcept model
    # is for a single set of two image files, so we have to do some janky stuff here to make it work.
    @cover_concept = CoverConcept.find_or_initialize_by(project_id: @project.id)
    @updated_file = nil
    update_hash = {}

    if ! params[:cover_concept_image].nil?
      update_hash[:cover_concept_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:cover_concept_content_type] = params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:cover_concept_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:cover_concept_image_direct_upload_url] = params[:cover_concept_image]['direct_upload_url'] unless params[:cover_concept_image]['direct_upload_url'].nil?
      update_hash[:cover_concept_image_processed] = false
      @updated_file = 'cover_concept_image'
    end

    if ! params[:stock_cover_image].nil?
      update_hash[:stock_cover_image_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:stock_cover_image_content_type] = params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:stock_cover_image_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:stock_cover_image_direct_upload_url] = params[:stock_cover_image]['direct_upload_url'] unless params[:stock_cover_image]['direct_upload_url'].nil?
      update_hash[:stock_cover_image_processed] = false
      @updated_file = 'stock_cover_image'
    end

    @cover_concept.update(update_hash)
    @cover_concept.save
    @last_errors = @cover_concept.errors.full_messages
    return
  end

end
