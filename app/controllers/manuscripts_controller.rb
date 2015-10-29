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

    Manuscript::MANUSCRIPT_VERSIONS.each do |version|
      if params[version.to_sym]
        update_hash[(version + '_file_name').to_sym]              = params[:filename] if params[:filename].present?
        update_hash[(version + '_content_type').to_sym]           = params[:filetype] if params[:filetype].present?
        update_hash[(version + '_file_size').to_sym]              = params[:filesize] if params[:filesize].present?
        update_hash[(version + '_file_direct_upload_url').to_sym] = params[version]['direct_upload_url'] if params[version]['direct_upload_url'].present?
        update_hash[(version + '_file_processed').to_sym]         = false
        @updated_file = version
      end
    end

    @manuscript.update(update_hash)
    @last_errors = @manuscript.errors.full_messages
    return
  end

  def update
    updated = []

    Manuscript::MANUSCRIPT_VERSIONS.each do |version|
      human_version = version.gsub('_', ' ').titleize
      if params[version.to_sym] == 'yes'
        updated.push(human_version)
        ProjectMailer.send('manuscript_' + version, @project, current_user)
      end
    end

    if updated.present?
      activity_text = "Uploaded a new version of: #{updated.join(', ')} for "
      @project.create_activity :edited_manuscripts, owner: current_user,
                             parameters: { text: activity_text, object_id: @manuscript.id, form_data: ''}
    end

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
