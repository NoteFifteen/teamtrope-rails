class FinalManuscriptsController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff, except: :create
  before_action :set_final_manuscript, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @final_manuscripts = FinalManuscript.all
  end

  def show
  end

  def create
    @project = Project.friendly.find(params[:project_id])

    # All examples (and code, really) seem to prefer a controller per file, whereas the Final Manuscripts model
    # is for a single set of two documents, so we have to do some janky stuff here to make it work.
    @final_manuscript = FinalManuscript.find_or_initialize_by(project_id: @project.id)
    @updated_file = nil

    if ! params[:final_manuscript_pdf].nil?
      @final_manuscript.update(
        pdf_file_name: params[:filename],
        pdf_content_type: params[:filetype],
        pdf_file_size: params[:filesize],
        pdf_direct_upload_url: params[:final_manuscript_pdf]['direct_upload_url']
      )
      @updated_file = 'pdf'
    end

    if ! params[:final_manuscript_doc].nil?
      @final_manuscript.update(
        doc_file_name: params[:filename],
        doc_content_type: params[:filetype],
        doc_file_size: params[:filesize],
        doc_direct_upload_url: params[:final_manuscript_doc]['direct_upload_url']
      )
      @updated_file = 'doc'
    end

    @final_manuscript.save

  end

  private
    def set_final_manuscript
      @final_manuscript = FinalManuscript.find(params[:id])
    end

    def set_project
      @project = FinalManuscript.find(params[:id]).project
    end

end
