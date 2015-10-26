class CoverConceptsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: [:create, :show]
  before_action :set_cover_concept, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /cover_concepts
  # GET /cover_concepts.json
  def index
    @cover_concepts = CoverConcept.all
  end

  # GET /cover_concepts/1
  # GET /cover_concepts/1.json
  def show
  end

  # This controller method is hit remotely via AJAX from a Project view.
  def create
    @project = Project.friendly.find(params[:project_id])

    # All examples (and code, really) seem to prefer a controller per file, whereas the CoverConcept model
    # is for a single set of two image files, so we have to do some janky stuff here to make it work.
    @cover_concept = CoverConcept.find_or_initialize_by(project_id: @project.id)
    @updated_file = nil
    update_hash = {}

    if ! params[:cover_concept].nil?
      update_hash[:cover_concept_file_name] = params[:filename] unless params[:filename].nil? || params[:filename] == ''
      update_hash[:cover_concept_content_type] = params[:filetype] unless params[:filetype].nil? || params[:filetype] == ''
      update_hash[:cover_concept_file_size] = params[:filesize] unless params[:filesize].nil? || params[:filesize] == ''
      update_hash[:cover_concept_direct_upload_url] = params[:cover_concept]['direct_upload_url'] unless params[:cover_concept]['direct_upload_url'].nil?
      update_hash[:cover_concept_processed] = false
      @updated_file = 'cover_concept'
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

  def update

    activity_text = nil
    send_cover_concept_email = false
    send_stock_image_email = false
    if !params[:updated_cover_concept].nil? && params[:updated_cover_concept] == "yes"
      activity_text = "Updated Cover Concept Image"
      send_cover_concept_email = true
    end

    if !params[:updated_stock_cover_image].nil? && params[:updated_stock_cover_image] == "yes"
      if activity_text.nil?
        activity_text = "Updated Stock Cover Image"
      else
        activity_text = "#{activity_text} and Stock Cover Image"
      end
      send_stock_image_email = true
    end

    unless activity_text.nil?
      @project.create_activity :submitted_price_promotion, owner: current_user,
                               parameters: {text: activity_text,
                               form_data: params[:project].to_s}
    end

    ProjectMailer.cover_concept_upload(@project, current_user) if send_cover_concept_email
    ProjectMailer.add_stock_cover_image(@project, current_user) if send_stock_image_email

    redirect_to @cover_concept
  end

  private
    def set_cover_concept
      @cover_concept = CoverConcept.find(params[:id])
    end

    def set_project
      @project = @cover_concept.project
    end

end
