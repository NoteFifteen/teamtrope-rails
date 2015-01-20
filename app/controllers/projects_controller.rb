class ProjectsController < ApplicationController
	before_action :signed_in_user, only: [:show, :index, :destroy, :edit]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
  	@projects = Project.all
  end
  
  def new
  	@project = Project.new
  end

  def edit
  end
  
  def create
  	@project = Project.new(new_project_params)
  	if @project.save
  		flash[:success] = "New Project Created!"
  		redirect_to projects_path
  	else
  		render 'new'
  	end
  end
  
  def destroy
    @project.destroy
    flash[:notice] = "Project has been destroyed."
    redirect_to projects_path
  end
  
  def update
		if @project.update(update_project_params)
			flash[:success] = "Updated"
			redirect_to @project
		else
			if params[:submitted_from_action] && params[:submitted_from_action] == 'show'
				render 'show'
			else
				render 'edit'
			end
		end
  end
  
  def show
	
  end
  
  private
  def new_project_params
  	params.require(:project).permit(:final_title)
  end
  
  def update_project_params
  	params.require(:project).permit(:id, :project_type_id,:final_doc_file,:final_manuscript_pdf,:final_pdf,:stock_image_request_link,:pcr_step_date,:layout_notes,:previously_published,:prev_publisher_and_date,:stock_cover_image,:cover_concept_notes,:proofed_word_count,:cover_concept,:pcr_step,:teamroom_link,:final_mobi,:publication_date,:final_epub,:production_exception_date,:marketing_release_date,:production_exception_reason,:production_exception_approver,:production_exception,:paperback_cover_type,:age_range,:search_terms,:bisac_code_3,:bisac_code_2,:bisac_code_1,:ebook_price,:print_price,:blurb_one_line,:endorsements,:author_bio,:blurb_description,:final_title,:cover_art_approval_date,:alternative_cover_template,:createspace_cover,:lightning_source_cover,:ebook_front_cover,:layout_approved_date,:final_page_count,:layout_upload,:use_pen_name_on_title,:use_pen_name_for_copyright,:exact_name_on_copyright,:pen_name,:special_text_treatment,:has_sub_chapters,:layout_style_choice,:has_index,:non_standard_size,:has_internal_illustrations,:color_interior,:manuscript_edited,:childrens_book,:project_manager,:other_pct,:manuscript_proofed,:proofreader_pct,:genre,:designer_pct,:editor_pct,:manager_pct,:project_manager_pct,:edit_complete_date,:author_pct,:other3,:other2,:other,:author,:editor,:marketing_manager,:manuscript_original,:cover_designer,:proofreader,:other3_pct,:other2_pct,:apple_id,:asin,:epub_isbn_no_dash,:createspace_isbn,:hardback_isbn,:lsi_isbn,:isbn,:ebook_isbn,:parse_id, :step_mkt_info,:step_cover_design,:genre_ids => [])
  end
  
  def set_project
  	@project = Project.find(params[:id])
  	rescue ActiveRecord::RecordNotFound
  		flash[:alert] = "The project you were looking for could not be found."
  		redirect_to projects_path
  end
  
end
