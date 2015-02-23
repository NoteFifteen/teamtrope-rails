class ProjectsController < ApplicationController
	before_action :signed_in_user #, only: [:show, :index, :destroy, :edit]
  before_action :set_project, except: [:create, :new, :index]

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
		@activities = PublicActivity::Activity.order("created_at DESC").where(trackable_type: "Project", trackable_id: @project)
  end
  
  
  # form actions
  
  def edit_complete_date
  	if @project.update(update_project_params)
  		@project.create_activity :submitted_edit_complete_date, owner: current_user, parameters: { text: " set the 'Edit Complete Date' to #{@project.edit_complete_date.strftime("%Y/%m/%d")}", form_data: params[:project]}
  		flash[:success] = "Edit Complete Date Set"
  		redirect_to @project
  	else
  		render 'show'
  	end
  end
  
  def original_manuscript
  	if @project.update(update_project_params)
  		@project.create_activity :submitted_original_manuscript, owner: current_user, parameters: {text: "Uploaded the Original Manuscript", form_data: params[:project]}
  		flash[:success] = "Original Manuscript Uploaded"
  		redirect_to @project
  	else
  		render 'show'
  	end
  end
  
  def edited_manuscript
  	if @project.update(update_project_params)
  		@project.create_activity :submitted_edited_manuscript, owner: current_user, parameters: {text: "Uploaded the Edited Manuscript", form_data: params[:project]}
  		flash[:success] = "Edited Manuscript Uploaded"
  		redirect_to @project
  	else
  		render 'show'
  	end
  end
  
  private
  def new_project_params
  	params.require(:project).permit(:final_title)
  end
  
  def update_project_params
  	params.require(:project).permit(:id, :final_doc_file, :final_manuscript_pdf, :final_pdf, :stock_image_request_link, :layout_notes, :previously_published, :prev_publisher_and_date, :stock_cover_image, :cover_concept_notes, :proofed_word_count, :cover_concept, :teamroom_link, :final_mobi, :publication_date, :final_epub, :marketing_release_date, :paperback_cover_type, :age_range, :search_terms, :bisac_code_3, :bisac_code_2, :bisac_code_1, :ebook_price, :print_price, :blurb_one_line, :endorsements, :author_bio, :blurb_description, :final_title, :cover_art_approval_date, :alternative_cover_template, :createspace_cover, :lightning_source_cover, :ebook_front_cover, :layout_approved_date, :final_page_count, :layout_upload, :use_pen_name_on_title, :use_pen_name_for_copyright, :exact_name_on_copyright, :pen_name, :special_text_treatment, :has_sub_chapters, :layout_style_choice, :has_index, :non_standard_size, :has_internal_illustrations, :color_interior, :manuscript_edited, :childrens_book, :manuscript_proofed, :edit_complete_date, :manuscript_original, :genre_ids => [])
  end
  
  def set_project
  	@project = Project.find(params[:id])
  	rescue ActiveRecord::RecordNotFound
  		flash[:alert] = "The project you were looking for could not be found."
  		redirect_to projects_path
  end
  
end
