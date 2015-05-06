class ProjectsController < ApplicationController
  before_action :signed_in_user #, only: [:show, :index, :destroy, :edit]
  before_action :set_project, except: [:create, :new, :index]

  include ProjectsHelper

  def index
    get_projects_for_index(params[:show])
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    author_percentage = RequiredRole.joins(:project_type, :role).where("project_types.id = ? AND roles.name = ?", params[:project][:project_type_id], 'Author').first.suggested_percent
    params[:project][:team_memberships_attributes]['0'][:percentage] = author_percentage
    params[:project][:final_title] = params[:project][:title]

    @project = Project.new(new_project_params)
    if @project.save
      flash[:success] = 'New Project Created!'
     # Need to create method to set the current tasks based on the workflow
      @project.create_workflow_tasks
      redirect_to projects_path
    else
      flash[:danger] = 'Error creating project!'
      render 'new'
    end
  end

  def destroy
    @project.destroy
    flash[:info] = "Project has been destroyed."
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
    @users = User.all
  end


  # form actions
  # TODO: form_data is now saved using to_s instead of passing the params array.
  # this prevents a crash when there is a temp file in params. Might want to come up with
  # a cleaner solution

  def update_status
    if @project.update(update_project_params)
      @project.create_activity :update_status, owner: current_user,
                               parameters: { text: ' posted a status update', form_data: params[:project].to_s}
      update_current_task

      flash[:success] = 'Posted Status Update'
      redirect_to @project
    else
      render 'show'
    end
  end

  def accept_team_member
    if @project.update(update_project_params)
      @project.create_activity :accept_team_member, owner: current_user,
                               parameters: { text: ' added new team member', form_data: params[:project].to_s}
      update_current_task
      Booktrope::ParseWrapper.save_revenue_allocation_record_to_parse @project, current_user, DateTime.parse("#{params[:effective_date][:year]}/#{params[:effective_date][:month]}/#{params[:effective_date][:day]}")


      flash[:success] = 'Accepted a Team Member'
      redirect_to @project
    else
      flash[:danger] = 'There was a problem adding a member to the team.  Please go to the Accept Member tab and review the errors.'
      render 'show'
    end
  end

  def submit_form_1099
    # This data is sensitive. We do not store it locally.
    # instead we store it in box.

    #upload_1099_data returns true or Boxr::BoxrError
    result = Booktrope::BoxrWrapper.upload_1099_data(params[:form_1099])
    if result && result.class != Boxr::BoxrError
      flash[:success] = 'Submitted 1099'
      redirect_to @project
    else

      if result.class == Boxr::BoxrError
        msg = result.to_s
      else
        msg = "There was an error #{result.to_s}"
      end


      flash[:danger] = msg
      render 'show'
    end

  end

  def remove_team_member
    # Parameters are spread around and need to be used on multiple objects
    project_id = params[:id]
    member_attributes = params[:project][:audit_team_membership_removals_attributes]['0']
    membership_id = member_attributes[:member_id]

    team_membership = @project.team_memberships.where(id: membership_id).first
    if !team_membership.nil?
      # Add audit
      audit_params = {
          project_id: project_id,
          member_id: team_membership.member_id,
          role_id: team_membership.role_id,
          percentage: team_membership.percentage,
          reason: member_attributes[:reason],
          notes: (member_attributes[:reason] == 'other') ? params[:other] : nil,
          notified_member: member_attributes[:notified_member]
      }

      audit = AuditTeamMembershipRemoval.new(audit_params)
      audit.save
      team_membership.destroy

      # Schedule update in parse for the 1st of next month or today if it's the 1st
      Booktrope::ParseWrapper.save_revenue_allocation_record_to_parse @project, current_user, (DateTime.now.day == 1) ? DateTime.now : DateTime.now.next_month.at_beginning_of_month

      @project.create_activity :removed_team_member,
                               owner: current_user, parameters: { text: ' Removed team member', form_data: audit_params.to_s}
      flash[:success] = 'Removed a team member'

      redirect_to @project
    else
      flash[:danger] = 'Error while removing a team member'
      render 'show'
    end
  end

  def edit_complete_date
    if @project.update(update_project_params)
      @project.create_activity :submitted_edit_complete_date, owner: current_user, parameters: { text: " set the 'Edit Complete Date' to #{@project.edit_complete_date.strftime("%Y/%m/%d")}", form_data: params[:project].to_s}
      flash[:success] = "Edit Complete Date Set"
      update_current_task
      redirect_to @project
    else
      render 'show'
    end
  end

  # sets the revenue allocation per team_membership
  def revenue_allocation_split
    if @project.update(update_project_params)

      @project.create_activity :revenue_allocation_split, owner: current_user, parameters: { text: " set the revenue allocation split", form_data: params[:project][:team_memberships_attributes].to_s}
      update_current_task
      Booktrope::ParseWrapper.save_revenue_allocation_record_to_parse @project, current_user, DateTime.parse("#{params[:effective_date][:year]}/#{params[:effective_date][:month]}/#{params[:effective_date][:day]}")

      #TODO: Hellosign-rails integration

      flash[:success] = "Revenue Allocation Split Set"
      redirect_to @project
    else
      render 'show'
    end
  end

  def original_manuscript
    if @project.update(update_project_params)
      @project.create_activity :submitted_original_manuscript, owner: current_user, parameters: {text: "Uploaded the Original Manuscript", form_data: params[:project].to_s}
      flash[:success] = "Original Manuscript Uploaded"
      update_current_task
      redirect_to @project
    else
      render 'show'
    end
  end

  def edited_manuscript
    if @project.update(update_project_params)
      @project.create_activity :submitted_edited_manuscript, owner: current_user, parameters: {text: "Uploaded the Edited Manuscript", form_data: params[:project].to_s}
      update_current_task
      flash[:success] = "Edited Manuscript Uploaded"
      redirect_to @project
    else
      render 'show'
    end
  end

  def proofed_manuscript
    if @project.update(update_project_params)
      @project.create_activity :submitted_proofed_manuscript, owner: current_user, parameters: {text: "Uploaded the Proofed Manuscript", form_data: params[:project].to_s}
      update_current_task
      flash[:success] = "Proofed Manuscript Uploaded"
      redirect_to @project
    else
      render 'show'
    end
  end

  def layout_upload
    if @project.update(update_project_params)
      @project.create_activity :uploaded_layout, owner: current_user,
                               parameters: {text: "Uploaded the Layout", form_data: params[:project].to_s}
      flash[:success] = "Layout Uploaded"
      update_current_task
      redirect_to @project
    else
      flash[:danger] = "Layout Upload failed - Please verify you're using the appropriate file type."
      render 'show'
    end
  end

  def kdp_select
    if @project.update(update_project_params)
      # update_current_task
      @project.create_activity :kdp_select_enrolled, owner: current_user,
                               parameters: { text: 'Enrolled in KDP Select', form_data: params[:project].to_s}
      flash[:success] = 'Enrolled in KDP Select'
      redirect_to @project
    else
      render 'show'
    end
  end


  def kdp_update
    # @todo At the moment this function just stores data, but in the future it may be necessary to track the
    #       dates surrounding enrollment and the expiration, when it's activated, etc.  It may also be necessary
    #       to limit when updates can be made (such as if a certain promo is already running).

    # The form passes back a bunch of variables not related to KdpSelectEnrollment so we
    # have to rewrite them here.
    kdp_update_attributes = params[:project][:kdp_select_enrollment_attributes]

    kdp_select = @project.kdp_select_enrollment
    if !kdp_select.nil?
      # update the kdp_select record
      kdp_params = {
          member_id: current_user.id,
          update_type: kdp_update_attributes[:update_type],
          update_data: kdp_update_attributes[:update_data]
      }
      if kdp_select.update(kdp_params)
        @project.create_activity :kdp_select_updated, owner: current_user,
                                 parameters: { text: 'Updated KDP Select', form_data: kdp_update_attributes.to_s}
        flash[:success] = 'Updated KDP Select'
        redirect_to @project
      else
        flash[:danger] = 'Error updating KDP enrollment record!'
        render 'show'
      end
    else
      flash[:danger] = 'Could not find an enrollment record!'
      render 'show'
    end
  end

  def cover_concept_upload
    if @project.update(update_project_params)
      @project.create_activity :uploaded_cover_concept, owner: current_user,
                               parameters: {text: 'Uploaded the Cover Concept', form_data: params[:project].to_s}
      flash[:success] = 'Cover Concept Uploaded'
      update_current_task
      redirect_to @project
    else
      flash[:danger] = 'Error uploading Cover Concept'
      render 'show'
    end
  end

  def edit_control_numbers
    @control_number = @project.control_number
    @control_number ||= @project.build_control_number

    if @control_number.update(update_control_number_params)
      # Update the record in Parse
      Booktrope::ParseWrapper.update_project_control_numbers @control_number

      # Record activity here
      @project.create_activity :updated_control_numbers, owner: current_user,
                               parameters: {text: "Updated the Control Numbers", form_data: params[:project].to_s}
      flash[:success] = "Updated the Control Numbers"
    else
      render 'show'
    end

    redirect_to @project
  end

  def edit_layout_style
    if @project.update(update_project_params)
      @project.create_activity :edited_layout_style, owner: current_user,
                               parameters: {text: 'Chose Layout Style', form_data: params[:project].to_s}
      flash[:success] = 'Layout Style Updated'
      update_current_task
      redirect_to @project
    else
      render 'show'
    end
  end

  def approve_layout
    # Set the approval date
    @project.layout.touch(:layout_approved_date)

    if @project.update(update_project_params)
      update_current_task
      activity_text = (:approved_layout == 'approved_revisions') ? 'Approved the layout' : 'Approved the layout with changes'
      @project.create_activity :approved_layout, owner: current_user,
                               parameters: { text: activity_text, form_data: params[:project].to_s }
      flash[:success] = 'Approved the Layout'
      redirect_to @project
    else
      render 'show'
    end
  end

  def price_promotion

    if @project.update(update_project_params)

      @project.create_activity :submitted_price_promotion, owner: current_user,
                               parameters: {text: 'submitted a price promotion',
                               form_data: params[:project].to_s}

      update_current_task
      flash[:success] = 'Price Promotion Submitted.'
      redirect_to @project
    else
      render 'show'
    end

  end

  def approve_blurb
    # This is an attribute accessor used as a flag for deciding what to update below
    approved = (params[:project][:approve_blurb_attributes][:blurb_approval_decision] == 'true')

    if @project.update(update_project_params)
      if approved
        # Set the approval date & wipe notes
        @project.approve_blurb.touch(:blurb_approval_date)
        # @project.approve_blurb.update_attribute(:blurb_notes, nil)
        update_current_task
        activity_text = 'Approved the Blurb'
        flash[:success] = activity_text
      else
      # Not approved, revert to previous step
        if @project.approve_blurb.update_attribute(:blurb_notes, params[:project][:blurb_notes])
          reject_current_task
          activity_text = 'Rejected the Blurb'
          flash[:success] = activity_text
        else
          # Some sort of failure updating the model.
          flash[:danger] = 'An error occurred during update'
          render 'show'
        end
      end
    else
      render 'show'
    end


    if ! activity_text.nil?
      @project.create_activity :approved_blurb, owner: current_user,
                               parameters: { text: activity_text, form_data: params[:project].to_s }
      redirect_to @project
    end
  end

  def approve_cover_art
    # This is an attribute accessor used as a flag for deciding what to update below
    approved = (params[:project][:cover_art_approval_decision] == 'true')

    if approved
      # Set the approval date & wipe notes
      @project.cover_concept.touch(:cover_art_approval_date)
      @project.cover_concept.update_attribute(:cover_concept_notes, nil)
      update_current_task
      activity_text = 'Approved the Cover Art'
      flash[:success] = activity_text
    else
    # Not approved, revert to previous step
      if @project.cover_concept.update_attribute(:cover_concept_notes, params[:project][:cover_concept_notes])
        reject_current_task
        activity_text = 'Rejected the Cover Art'
        flash[:success] = activity_text
      else
        # Some sort of failure updating the model.
        flash[:danger] = 'An error occurred during update'
        render 'show'
      end
    end

    if ! activity_text.nil?
      @project.create_activity :approved_cover_art, owner: current_user,
                               parameters: { text: activity_text, form_data: params[:project].to_s }
      redirect_to @project
    end
  end

  def add_stock_cover_image
    if @project.update(update_project_params)
      @project.create_activity :stock_cover_image_uploaded, owner: current_user,
                               parameters: {text: 'Uploaded the Stock Cover Image', form_data: params[:project].to_s}
      flash[:success] = 'Stock Cover Image Uploaded'
      update_current_task
      redirect_to @project
    else
      flash[:danger] = 'Error uploading Stock Cover Image.  Are you sure your file was in .jpg or .zip format?'
      render 'show'
    end
  end

  def request_images
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :requested_images, owner: current_user,
                               parameters: { text: 'Requested Images', form_data: params[:project].to_s }
      flash[:success] = 'Requested Images'
      redirect_to @project
    else
      render 'show'
    end
  end

  def update_final_page_count
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :updated_final_page_count, owner: current_user,
                                parameters: { text: 'Updated Final Page Count', form_data: params[:project].to_s}
      flash[:success] = 'Updated Final Page Count'
      redirect_to @project
    else
        render 'show'
    end
  end

  def upload_cover_templates
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :uploaded_cover_templates, owner: current_user,
                                parameters: { text: 'Uploaded Cover Templates', form_data: params[:project].to_s}
      flash[:success] = 'Uploaded Cover Templates'
      redirect_to @project
    else
        render 'show'
    end
  end

  def artwork_rights_request
    if @project.update(update_project_params)
      @project.create_activity :artwork_rights_request, owner: current_user,
                               parameters: { text: 'Updated the Artwork Rights Requests', form_data: params[:project].to_s}
      flash[:success] = 'Updated Artwork Rights Requests'
      redirect_to @project
    else
      flash[:danger] = 'An error occurred while attempting to update the Artwork Rights Requests'
      render 'show'
    end

  end

  def submit_blurb
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :submitted_blurb, owner: current_user,
                                parameters: { text: 'Submitted the Draft Blurb', form_data: params[:project].to_s}
      flash[:success] = 'Submitted Draft Blurb'
      redirect_to @project
    else
      render 'show'
    end
  end

  def submit_pfs
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :submitted_pfs, owner: current_user,
                                parameters: { text: 'Submitted the Publication Fact Sheet', form_data: params[:project].to_s}
      flash[:success] = 'Submitted Publication Fact Sheet'
      redirect_to @project
    else
      render 'show'
    end
  end

  def final_manuscript
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :uploaded_final_manuscript, owner: current_user,
                                parameters: { text: 'Uploaded Final Manuscript', form_data: params[:project].to_s}
      flash[:success] = 'Uploaded Final Manuscript'
      redirect_to @project
    else
      render 'show'
    end
  end

  def publish_book
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :published_book, owner: current_user,
                                parameters: { text: 'Submitted the Publish Book form', form_data: params[:project].to_s}
      flash[:success] = 'Congratulations! Your book has been published'
      redirect_to @project
    else
      render 'show'
    end
  end

  def marketing_release_date
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :marketing_release_date, owner: current_user,
                                parameters: { text: 'Set Marketing Release Date', form_data: params[:project].to_s}
      flash[:success] = 'Marketing Release Date Set'
      redirect_to @project
    else
      render 'show'
    end
  end

  def media_kit
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :media_kit, owner: current_user,
                                parameters: { text: 'Uploaded Media Kit', form_data: params[:project].to_s}
      flash[:success] = 'Media Kit Uploaded.'
      redirect_to @project
    else
      render 'show'
    end
  end

  def blog_tour
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :blog_tour, owner: current_user,
          parameters: { text: 'Scheduled a Blog Tour', form_data: params[:project].to_s}
      flash[:success] = 'Blog Tour Scheduled.'
      redirect_to @project
    else
      render 'show'
    end
  end

  def marketing_expense
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :marketing_expense, owner: current_user,
          parameters: { text: 'Submitted a Marketing Expense', form_data: params[:project].to_s}
      flash[:success] = 'Submitted Marketing Expense.'
      redirect_to @project
    else
      render 'show'
    end
  end

  def download_original_manuscript
    redirect_to @project.manuscript.original.expiring_url(*Constants::DefaultLinkExpiration)
  end

    def download_edited_manuscript
    redirect_to @project.manuscript.edited.expiring_url(*Constants::DefaultLinkExpiration)
  end

    def download_proofed_manuscript
    redirect_to @project.manuscript.proofed.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_published_file_mobi
    redirect_to @project.published_file.mobi.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_published_file_epub
    redirect_to @project.published_file.epub.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_published_file_pdf
    redirect_to @project.published_file.pdf.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_media_kits
    redirect_to @project.media_kits.document.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_layout
    redirect_to @project.layout.layout_upload.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_final_manuscript_pdf
    redirect_to @project.final_manuscript.pdf.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_final_manuscript_doc
    redirect_to @project.final_manuscript.doc.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_alternate_cover
    redirect_to @project.cover_template.alternate_cover.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_createspace_cover
    redirect_to @project.cover_template.createspace_cover.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_ebook_front_cover
    redirect_to @project.cover_template.ebook_front_cover.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_lightning_source_cover
    redirect_to @project.cover_template.lightning_source_cover.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_cover_concept
    redirect_to @project.cover_concept.cover_concept.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_stock_cover_image
    redirect_to @project.cover_concept.stock_cover_image.expiring_url(*Constants::DefaultLinkExpiration)
  end

  private
  def new_project_params
    params.require(:project).permit(:title, :final_title, :project_type_id, :genre_ids => [], :team_memberships_attributes => [:role_id, :member_id, :percentage])
  end

  def update_project_params
    params.require(:project).permit(:id, :final_title, :stock_image_request_link,
      :previously_published, :prev_publisher_and_date, :proofed_word_count, :teamroom_link,
      :publication_date, :marketing_release_date, :special_text_treatment, :has_sub_chapters, :has_index,
      :non_standard_size, :has_internal_illustrations, :color_interior, :childrens_book,
      :edit_complete_date, :imprint_id,
      :genre_ids => [],
      :artwork_rights_requests_attributes => [:id, :role_type, :full_name, :email, :_destroy],
      :blog_tours_attributes => [:cost, :tour_type, :blog_tour_service, :number_of_stops, :start_date, :end_date],
      :cover_concept_attributes => [:id, :cover_concept, :cover_concept_notes, :cover_art_approval_date, :stock_cover_image, :image_request_list],
      :cover_template_attributes => [:ebook_front_cover, :createspace_cover, :lightning_source_cover, :alternative_cover],
      :draft_blurb_attributes => [:id, :draft_blurb],
      :approve_blurb_attributes => [:id, :blurb_approval_decision, :blurb_approval_date, :blurb_notes],
      :final_manuscript_attributes => [:id, :pdf, :doc],
      :kdp_select_enrollment_attributes => [:member_id, :enrollment_date, :update_type, :update_data],
      :layout_attributes => [:id, :layout_style_choice, :page_header_display_name, :use_pen_name_on_title, :pen_name,
                             :use_pen_name_for_copyright, :exact_name_on_copyright, :layout_upload, :layout_notes,
                             :layout_approved, :layout_approved_date, :layout_approval_issue_list, :final_page_count],
      :manuscript_attributes => [:id, :original, :edited, :proofed],
      :marketing_expenses_attributes => [:invoice_due_date, :start_date, :end_date, :expense_type, :service_provider, :cost, :other_information ],
      :media_kits_attributes => [:document],
      :price_change_promotions_attributes => [:type, :start_date, :price_promotion, :end_date, :price_after_promotion],
      :publication_fact_sheet_attributes => [ :author_name, :series_name, :series_number, :description,
            :author_bio, :endorsements, :one_line_blurb, :print_price, :ebook_price,
            :bisac_code_one, :bisac_code_two, :bisac_code_three, :search_terms, :age_range,
            :paperback_cover_type ],
      :published_file_attributes => [:publication_date, :mobi, :epub, :pdf],
      :status_updates_attributes => [:type, :status],
      :team_memberships_attributes => [:id, :role_id, :member_id, :percentage, :_destroy]
      )
  end

  def update_control_number_params
    params.require(:control_number).permit(:id, :imprint, :ebook_library_price, :asin, :apple_id, :epub_isbn,
                                           :hardback_isbn, :paperback_isbn, :parse_id)
  end

  def set_project
    @project = Project.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = "The project you were looking for could not be found."
      redirect_to projects_path
  end

  def update_current_task
    current_task = @project.current_tasks.where(task_id: params[:submitted_task_id]).first
    unless current_task.nil? || current_task.task.next_task.nil?
      current_task.task_id = current_task.task.next_task.id
      current_task.save
    end
  end

  def reject_current_task
    current_task = @project.current_tasks.where(task_id: params[:submitted_task_id]).first
    unless current_task.nil? || current_task.task.rejected_task.nil?
      current_task.task_id = current_task.task.rejected_task.id
      current_task.save
    end
  end

  def team_memberships_params
    params.require(:team_membership).permit(:role_id, :member_id, :percentage)
  end
end
