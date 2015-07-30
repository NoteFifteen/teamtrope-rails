class ProjectsController < ApplicationController

  before_action :signed_in_user #, only: [:show, :index, :destroy, :edit]
  before_action :set_project, except: [:create, :new, :index, :grid_view]

  include ProjectsHelper
  include Wisper::Publisher

  def index
    get_projects_for_index(params)
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    author_percentage = RequiredRole.joins(:project_type, :role).where('project_types.id = ? AND roles.name = ?', params[:project][:project_type_id], 'Author').first.suggested_percent
    params[:project][:team_memberships_attributes]['0'][:percentage] = author_percentage
    params[:project][:final_title] = params[:project][:title]

    @project = Project.new(new_project_params)
    if @project.save
      flash[:success] = 'Welcome to your new Project!'
     # Need to create method to set the current tasks based on the workflow
      @project.create_workflow_tasks
      publish(:create_project, @project)
      ProjectMailer.project_created(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'Error creating project!'
      render 'new'
    end
  end

  def destroy
    @project.destroy
    flash[:info] = 'Project has been destroyed.'
    redirect_to projects_path
  end

  def update
    if @project.update(update_project_params)
      publish(:modify_project, @project)
      flash[:success] = 'Updated Project'
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
    @activities = PublicActivity::Activity.order('created_at DESC').where(trackable_type: 'Project', trackable_id: @project)
    @users = User.all
    @current_user = current_user
  end

  def grid_view
    @project_grid_table_rows = ProjectGridTableRow.includes(:project).all.order(title: :asc)
  end

  # form actions
  # TODO: form_data is now saved using to_s instead of passing the params array.
  # this prevents a crash when there is a temp file in params. Might want to come up with
  # a cleaner solution

  def accept_team_member
    if @project.update(update_project_params)
      @project.create_activity :accept_team_member, owner: current_user,
                               parameters: { text: ' added new team member', form_data: params[:project].to_s}

      publish(:modify_team_member, @project, params[:project][:team_memberships_attributes]['0'][:role_id])
      update_current_task
      Booktrope::ParseWrapper.save_revenue_allocation_record_to_parse @project, current_user, DateTime.parse("#{params[:effective_date][:year]}/#{params[:effective_date][:month]}/#{params[:effective_date][:day]}")

      ProjectMailer.accepted_team_member(@project, current_user, params)
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
      ProjectMailer.received_1099_form(@project, current_user)
      flash[:success] = 'Submitted 1099'
      redirect_to @project
    else

      if result.class == Boxr::BoxrError
        msg = result.to_s
      else
        msg = "There was an error saving the 1099 form: #{result.to_s}"
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

      # Have to do this before we destroy team membership so we can show the Member Name & Role in the Notification
      ProjectMailer.remove_team_member(@project, current_user, params)

      team_membership.destroy

      # publish that we destroyed the membership after we destroy it so they don't appear in the grid
      publish(:modify_team_member, @project, audit.role_id)

      # Schedule update in parse for the 1st of next month or today if it's the 1st
      Booktrope::ParseWrapper.save_revenue_allocation_record_to_parse @project, current_user, (DateTime.now.day == 1) ? DateTime.now : DateTime.now.next_month.at_beginning_of_month

      @project.create_activity :removed_team_member,
                               owner: current_user, parameters: { text: ' Removed team member', form_data: audit_params.to_s}
      flash[:success] = 'Removed a team member'

      redirect_to @project
    else
      flash[:danger] = 'An error was encountered while removing a team member, please review.'
      render 'show'
    end
  end

  def edit_complete_date
    if @project.update(update_project_params)
      @project.create_activity :submitted_edit_complete_date, owner: current_user, parameters: { text: " set the 'Edit Complete Date' to #{@project.edit_complete_date.strftime('%Y/%m/%d')}", form_data: params[:project].to_s}
      flash[:success] = 'Edit Complete Date Set'
      update_current_task
      redirect_to @project
    else
      flash[:danger] = 'An error occurred while setting the Edit Complete Date, please review.'
      render 'show'
    end
  end

  # sets the revenue allocation per team_membership
  def revenue_allocation_split
    if @project.update(update_project_params)
      effective_date = "#{params[:effective_date][:year]}/#{params[:effective_date][:month]}/#{params[:effective_date][:day]}"

      @project.create_activity :revenue_allocation_split, owner: current_user, parameters: { text: ' set the revenue allocation split', form_data: params[:project][:team_memberships_attributes].to_s}
      update_current_task
      ProjectMailer.rev_allocation_change(@project, current_user, effective_date)
      Booktrope::ParseWrapper.save_revenue_allocation_record_to_parse @project, current_user, DateTime.parse(effective_date)

      #TODO: Hellosign-rails integration

      flash[:success] = 'Revenue Allocation Split Set'
      redirect_to @project
    else
      flash[:danger] = 'There was an error saving the Revenue Allocation Split, please review.'
      render 'show'
    end
  end

  def original_manuscript
    @manuscript = Manuscript.find_or_initialize_by(project_id: @project.id)

    # Validate the file has been uploaded before moving forward
    if ! @manuscript.original.nil?
      @project.create_activity :submitted_original_manuscript, owner: current_user, parameters: {text: 'Uploaded the Original Manuscript', form_data: params[:project].to_s}
      flash[:success] = 'Original Manuscript Uploaded'
      update_current_task
      ProjectMailer.original_manuscript_uploaded(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was a problem Uploading your Original Manuscript, please review.'
      render 'show'
    end
  end

  def edited_manuscript
    @manuscript = Manuscript.find_or_initialize_by(project_id: @project.id)

    if ! @manuscript.edited.nil? && @project.update(update_project_params)
      @project.create_activity :submitted_edited_manuscript, owner: current_user, parameters: {text: 'Uploaded the Edited Manuscript', form_data: params[:project].to_s}
      update_current_task
      flash[:success] = 'Edited Manuscript Uploaded'
      ProjectMailer.submit_edited_manuscript(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was a problem Uploading your Edited Manuscript, please review.'
      render 'show'
    end
  end

  def proofed_manuscript
    @manuscript = Manuscript.find_or_initialize_by(project_id: @project.id)

    if @project.update(update_project_params)
      @project.create_activity :submitted_proofed_manuscript, owner: current_user, parameters: {text: 'Uploaded the Proofed Manuscript', form_data: params[:project].to_s}
      update_current_task
      flash[:success] = "Proofed Manuscript Uploaded. WAIT! Before you celebrate, you are still on the clock for the project and we won't be working on your book until you complete the next step.
      To do this:
        1) Refresh the  project page (see link below),
        2) Open the Choose Style tab in the Design Layout phase of the project.
        3) Submit Choose Style form. And that's it!"
      ProjectMailer.proofed_manuscript(@project, current_user, params)
      redirect_to @project
    else
      flash[:danger] = 'There was a problem Uploading your Proofed Manuscript, please review.'
      render 'show'
    end
  end

  def layout_upload
    if @project.update(update_project_params)
      @project.create_activity :uploaded_layout, owner: current_user,
                               parameters: {text: 'Uploaded the Layout', form_data: params[:project].to_s}
      flash[:success] = 'Layout Uploaded'
      update_current_task
      ProjectMailer.layout_upload(@project, current_user)
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
      ProjectMailer.kdp_select_enrollment(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was an error enrolling in KDP Select, please review.'
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

        ProjectMailer.kdp_select_update(@project, current_user)
        flash[:success] = 'Updated KDP Select Enrollment'
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
    @cover_concept = CoverConcept.find_or_initialize_by(project_id: @project.id)

    # Validate the file has been uploaded before moving forward
    if ! @cover_concept.cover_concept.nil?
      @project.create_activity :uploaded_cover_concept, owner: current_user,
                               parameters: {text: 'Uploaded the Cover Concept', form_data: params[:project].to_s}
      flash[:success] = 'Cover Concept Uploaded!'
      update_current_task
      ProjectMailer.cover_concept_upload(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'Error uploading Cover Concept.  Please try your upload again.'
      render 'show'
    end
  end

  def check_imprint
    if @project.update_attributes(update_project_params)
      publish(:modify_imprint, @project)

      Booktrope::ParseWrapper.update_project_control_numbers @project.control_number
      @project.create_activity :check_imprint, owner: current_user,
                              parameters: {text: 'Set the Imprint and Paperback ISBN', form_data: params[:project].to_s}
      flash[:success] = 'Set the Imprint and Paperback ISBN'
      update_current_task
      ProjectMailer.check_imprint(@project, current_user)
    else
      flash[:danger] = 'Error setting the Imprint and Paperback ISBN, please review.'
      render 'show'
    end
    redirect_to @project
  end

  def edit_control_numbers
    if @project.update(update_project_params)
      publish(:modify_imprint, @project)

      # Update the record in Parse
      Booktrope::ParseWrapper.update_project_control_numbers @project.control_number

      # Record activity here
      @project.create_activity :updated_control_numbers, owner: current_user,
                               parameters: {text: 'Updated the Control Numbers', form_data: params[:project].to_s}
      flash[:success] = 'Updated the Control Numbers'
      ProjectMailer.edit_control_numbers(@project, current_user)
    else
      flash[:danger] = 'Error updating the Control Numbers, please review.'
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
      ProjectMailer.edit_layout_style(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was a problem saving your Layout Style choices, please review.'
      render 'show'
    end
  end

  def approve_layout
    # Set the approval date
    @project.layout.touch(:layout_approved_date)

    if @project.update(update_project_params)
      update_current_task
      activity_text = (:approved_layout == 'approved_revisions') ? 'Approved the layout with changes' : 'Approved the layout'
      @project.create_activity :approved_layout, owner: current_user,
                               parameters: { text: activity_text, form_data: params[:project].to_s }
      flash[:success] = 'Approved the Layout'
      ProjectMailer.layout_approval(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was an error approving the Layout.  Please review.'
      render 'show'
    end
  end

  def price_promotion

    if @project.update(update_project_params)

      @project.create_activity :submitted_price_promotion, owner: current_user,
                               parameters: {text: 'submitted a price promotion',
                               form_data: params[:project].to_s}

      update_current_task
      ProjectMailer.price_promotion(@project, current_user)
      flash[:success] = 'Price Promotion Submitted.'
      redirect_to @project
    else
      flash[:danger] = 'There was an error submitting your Promotion.  Please review.'
      render 'show'
    end

  end

  def man_dev
    # This is an attribute accessor used as a flag for deciding what to update below
    approved = (params[:project][:man_dev_attributes][:man_dev_decision] == 'true')

    if @project.update(update_project_params)
      if approved
        # Set the approval date & wipe notes
        update_current_task
        activity_text = 'Manuscript Develoment Complete'
        flash[:success] = activity_text
      else
      # Not approved, revert to previous step
        reject_current_task
        activity_text = 'Manuscript Still In Development'
        flash[:success] = activity_text
      end
    else
      flash[:danger] = 'There was an error updating the Manuscript Development status.  Please review.'
      render 'show'
    end

    if ! activity_text.nil?
      @project.create_activity :approved_blurb, owner: current_user,
                               parameters: { text: activity_text, form_data: params[:project].to_s }
      redirect_to @project
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
        if @project.approve_blurb.update_attribute(:blurb_notes, params[:project][:approve_blurb_attributes][:blurb_notes])
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
      flash[:danger] = 'There was an error approving the blurb.  Please review.'
      render 'show'
    end

    ProjectMailer.approve_blurb(@project, current_user, approved)

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

      notes = params[:project][:cover_concept_notes].nil?? nil : params[:project][:cover_concept_notes]
      @project.cover_concept.update_attribute(:cover_concept_notes, notes)

      update_current_task
      activity_text = 'Approved the Cover Art'
      flash[:success] = activity_text
    else
    # Not approved, revert to previous step
      if @project.cover_concept.update_attribute(:cover_concept_notes, params[:project][:cover_concept_notes])
        @project.cover_concept.unapproved_cover_concept = @project.cover_concept.cover_concept
        @project.cover_concept.cover_concept = nil
        @project.cover_concept.save

        reject_current_task
        activity_text = 'Rejected the Cover Art'
        flash[:success] = activity_text
      else
        # Some sort of failure updating the model.
        flash[:danger] = 'An error occurred approving the Cover Art.  Please review.'
        render 'show'
      end
    end

    if ! activity_text.nil?
      @project.create_activity :approved_cover_art, owner: current_user,
                               parameters: { text: activity_text, form_data: params[:project].to_s }

      ProjectMailer.approve_cover_art(@project, current_user, approved)
      redirect_to @project
    end
  end

  def add_stock_cover_image
    @cover_concept = CoverConcept.find_or_initialize_by(project_id: @project.id)

    # Validate the file has been uploaded before moving forward
    if ! @cover_concept.stock_cover_image.nil?
      @project.create_activity :stock_cover_image_uploaded, owner: current_user,
                               parameters: {text: 'Uploaded the Stock Cover Image', form_data: params[:project].to_s}
      flash[:success] = 'Stock Cover Image Uploaded!'
      update_current_task
      ProjectMailer.add_stock_cover_image(@project, current_user)
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
      ProjectMailer.request_images(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was an error saving the requested images.  Please review.'
      render 'show'
    end
  end

  def update_final_page_count
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :updated_final_page_count, owner: current_user,
                                parameters: { text: 'Updated Final Page Count', form_data: params[:project].to_s}
      flash[:success] = 'Updated Final Page Count'
      ProjectMailer.update_final_page_count(@project, current_user)
      redirect_to @project
    else
        flash[:danger] = 'There was an error updating the Final Page Count.  Please review.'
        render 'show'
    end
  end

  def upload_cover_templates
    @cover_template = CoverTemplate.find_or_initialize_by(project_id: @project.id)

    # Validate the file has been uploaded before moving forward
    if ! @cover_template.ebook_front_cover.nil? &&
       ! @cover_template.createspace_cover.nil? &&
       ! @cover_template.lightning_source_cover.nil?

      @cover_template.update_attribute(:final_cover_approved, nil)

      update_current_task
      @project.create_activity :uploaded_cover_templates, owner: current_user,
                                parameters: { text: 'Uploaded Cover Templates', form_data: params[:project].to_s}
      flash[:success] = 'Uploaded Cover Templates'
      ProjectMailer.upload_cover_templates(@project, current_user, params)
      redirect_to @project
    else
      flash[:danger] = 'There was an error uploading the Cover Templates.  Please Review.'
      render 'show'
    end
  end

  def approve_final_cover
    # This is an attribute accessor used as a flag for deciding what to update below
    approved = (params[:project][:cover_template_attributes][:final_cover_approved] == 'true')
    @project.cover_template.update_attribute(:final_cover_approved, approved)

    if approved
      # Set the approval date & wipe notes
      @project.cover_template.touch(:final_cover_approval_date)

      notes = params[:project][:cover_template_attributes][:final_cover_notes].nil?? nil : params[:project][:cover_template_attributes][:final_cover_notes]
      @project.cover_template.update_attribute(:final_cover_notes, notes)

      update_current_task
      activity_text = 'Approved the Final Cover'
      flash[:success] = activity_text
    else
      # Not approved, revert to previous step
      if @project.cover_template.update_attribute(:final_cover_notes, params[:project][:cover_template_attributes][:final_cover_notes])
        reject_current_task
        activity_text = 'Rejected the Final Cover'
        flash[:success] = activity_text
      else
        # Some sort of failure updating the model.
        flash[:danger] = 'An error occurred during the Final Cover update, please review.'
        render 'show'
      end
    end

    if ! activity_text.nil?
      @project.create_activity :approved_final_cover, owner: current_user,
                               parameters: { text: activity_text, form_data: params[:project].to_s }

      ProjectMailer.approve_final_cover(@project, current_user, approved)
      redirect_to @project
    end
  end

  def artwork_rights_request
    if @project.update(update_project_params)
      @project.create_activity :artwork_rights_request, owner: current_user,
                               parameters: { text: 'Updated the Artwork Rights Requests', form_data: params[:project].to_s}
      flash[:success] = 'Updated Artwork Rights Requests'
      ProjectMailer.artwork_rights_request(@project, current_user)
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
                                parameters: { text: 'Submitted the Blurb', form_data: params[:project].to_s}
      flash[:success] = 'Submitted Blurb'
      ProjectMailer.submit_blurb(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was an error submitting the Draft Blurb.  Please review.'
      render 'show'
    end
  end

  def submit_pfs
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :submitted_pfs, owner: current_user,
                                parameters: { text: 'Submitted the Publication Fact Sheet', form_data: params[:project].to_s}
      flash[:success] = 'Submitted Publication Fact Sheet'
      ProjectMailer.publication_fact_sheet(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was a problem submitting the Publication Fact Sheet, please review.'
      render 'show'
    end
  end

  def final_manuscript
    update_current_task
    @project.create_activity :uploaded_final_manuscript, owner: current_user,
                              parameters: { text: 'Uploaded Final Manuscript', form_data: params[:project].to_s}
    flash[:success] = 'Uploaded Final Manuscript'
    ProjectMailer.final_manuscript(@project, current_user)
    redirect_to @project
  end

  def publish_book
    @published_file = PublishedFile.find_or_initialize_by(project_id: @project.id)

    publication_date = DateTime.parse("#{params[:project][:published_file_attributes]['publication_date(1i)']}/#{params[:project][:published_file_attributes]['publication_date(2i)']}/#{params[:project][:published_file_attributes]['publication_date(3i)']}").strftime("%Y/%m/%d")

    if @published_file.update(publication_date: publication_date)
      update_current_task
      @project.create_activity :published_book, owner: current_user,
                                parameters: { text: 'Submitted the Publish Book form', form_data: params[:project].to_s}
      flash[:success] = 'Congratulations! Your book has been published'
      ProjectMailer.publish_book(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was an error publishing the book.  Please review.'
      render 'show'
    end
  end

  def media_kit
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :media_kit, owner: current_user,
                                parameters: { text: 'Uploaded Media Kit', form_data: params[:project].to_s}
      flash[:success] = 'Media Kit Uploaded.'
      ProjectMailer.media_kit(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was an error uploading the Media Kit.  Please review.'
      render 'show'
    end
  end

  def blog_tour
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :blog_tour, owner: current_user,
          parameters: { text: 'Scheduled a Blog Tour', form_data: params[:project].to_s}
      flash[:success] = 'Blog Tour Scheduled.'
      ProjectMailer.blog_tour(@project, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was a problem scheduling the Blog Tour, please review.'
      render 'show'
    end
  end

  def production_expense
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :production_expense, owner: current_user,
        parameters: { text: 'Submitted a Production Expense', form_data: params[:project].to_s}
      flash[:success] = 'Submitted Production Expense'
      # getting the most recently created production expense
      # TODO: investigate a better way to look up the most recently created nested many to many relation
      production_expense = @project.production_expenses.order(created_at: :desc).where('created_at = updated_at').first
      ProjectMailer.production_expense(@project, production_expense, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was an error submitting the Production Expense.  Please review.'
      render 'show'
    end
  end

  def marketing_expense
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :marketing_expense, owner: current_user,
          parameters: { text: 'Submitted a Marketing Expense', form_data: params[:project].to_s}
      flash[:success] = 'Submitted Marketing Expense.'

      # getting the most recently created marketing expense
      # TODO: investigate a better way to look up the most recently created nested many to many relation
      marketing_expense = @project.marketing_expenses.order(created_at: :desc).where('created_at = updated_at').first
      ProjectMailer.marketing_expense(@project, marketing_expense, current_user)
      redirect_to @project
    else
      flash[:danger] = 'There was an error submitting the Marketing Expense.  Please review.'
      render 'show'
    end
  end

  def print_corner_request
    if @project.update(update_project_params)
      update_current_task
      @project.create_activity :marketing_expense, owner: current_user,
                               parameters: { text: 'Submitted a Print Copy Request', form_data: params[:project].to_s}
      flash[:success] = 'Submitted Print Copy Request.'
      redirect_to @project
      ProjectMailer.print_corner_request(@project, current_user)
    else
      flash[:danger] = 'There was a problem adding your Print Copy request.  Please review.'
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
    redirect_to @project.cover_template.alternative_cover.expiring_url(*Constants::DefaultLinkExpiration)
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

  def download_unapproved_cover_concept
    redirect_to @project.cover_concept.unapproved_cover_concept.expiring_url(*Constants::DefaultLinkExpiration)
  end

  def download_stock_cover_image
    redirect_to @project.cover_concept.stock_cover_image.expiring_url(*Constants::DefaultLinkExpiration)
  end

  # Booktrope Staff only function to allow them to revert to the previous workflow step
  def rollback_current_task
    current_task = @project.current_tasks.where(task_id: params[:current_workflow_task_id]).first
    unless current_task.nil?
      previous_task = Task.find_by_next_id(params[:current_workflow_task_id])

      activity_text = "Rolled back from #{current_task.task.name} to #{previous_task.name}"

      current_task.task = previous_task
      current_task.save

      @project.create_activity :rollback_current_task,
                               owner: current_user,
                               parameters: {
                                   text: activity_text,
                                   form_data: params[:project].to_s
                               }

    end
    redirect_to @project
  end

  private
  def new_project_params
    params.require(:project).permit(:title, :final_title, :project_type_id, :teamroom_link, :synopsis,
                                    :page_count, :has_internal_illustrations, :previously_published,
                                    :special_text_treatment, :imprint_id,
                                    :genre_ids => [], :team_memberships_attributes => [:role_id, :member_id, :percentage]
    )
  end

  def update_project_params
    params.require(:project).permit(:id, :final_title, :title, :synopsis, :stock_image_request_link,
      :previously_published, :previously_published_title, :previously_published_year, :previously_published_publisher,
      :credit_request, :proofed_word_count, :teamroom_link,
      :publication_date, :target_market_launch_date, :special_text_treatment, :has_sub_chapters, :has_index,
      :non_standard_size, :has_internal_illustrations, :color_interior, :childrens_book,
      :edit_complete_date, :imprint_id,
      :genre_ids => [],
      :artwork_rights_requests_attributes => [:id, :role_type, :full_name, :email, :_destroy],
      :blog_tours_attributes => [:cost, :tour_type, :blog_tour_service, :number_of_stops, :start_date, :end_date],
      :control_number_attributes => [:id, :ebook_library_price, :asin, :apple_id, :epub_isbn, :hardback_isbn,
                                     :paperback_isbn, :parse_id],
      :cover_concept_attributes => [:id, :cover_concept_notes, :cover_art_approval_date, :image_request_list],
      :cover_template_attributes => [:id, :final_cover_approved, :final_cover_approval_date, :final_cover_notes],
      :draft_blurb_attributes => [:id, :draft_blurb],
      :approve_blurb_attributes => [:id, :blurb_approval_decision, :blurb_approval_date, :blurb_notes],
      :final_manuscript_attributes => [:id, :pdf, :doc],
      :kdp_select_enrollment_attributes => [:member_id, :enrollment_date, :update_type, :update_data],
      :layout_attributes => [:id, :layout_style_choice, :page_header_display_name, :use_pen_name_on_title, :pen_name,
                             :use_pen_name_for_copyright, :exact_name_on_copyright, :layout_upload, :layout_notes,
                             :layout_approved, :layout_approved_date, :layout_approval_issue_list, :final_page_count, :trim_size, :trim_size_w, :trim_size_h],
      :manuscript_attributes => [:id, :original, :edited, :proofed],
      :marketing_expenses_attributes => [:invoice_due_date, :start_date, :end_date, :expense_type, :service_provider, :cost, :other_information , :other_type, :other_service_provider],
      :media_kits_attributes => [:document],
      :price_change_promotions_attributes => [:type, :start_date, :price_promotion, :end_date, :price_after_promotion, :sites => []],
      :production_expenses_attributes => [:additional_booktrope_cost, :additional_costs, :additional_team_cost, :author_advance_cost, :author_advance_quantity, :calculation_explanation, :complimentary_cost, :complimentary_quantity, :effective_date, :marketing_quantity, :marketing_cost, :paypal_invoice_amount, :purchased_cost, :purchased_quantity, :total_cost, :total_quantity_ordered],
      :publication_fact_sheet_attributes => [ :author_name, :series_name, :series_number, :description,
            :author_bio, :endorsements, :one_line_blurb, :print_price, :ebook_price,
            :bisac_code_one, :bisac_code_two, :bisac_code_three, :search_terms, :age_range,
            :paperback_cover_type ],
      :published_file_attributes => [:publication_date],
      :status_updates_attributes => [:type, :status],
      :team_memberships_attributes => [:id, :role_id, :member_id, :percentage, :_destroy],
      :print_corners_attributes => [:id, :user_id, :order_type, :first_order, :additional_order, :over_125, :billing_acceptance, :quantity, :has_author_profile, :has_marketing_plan,
                         :shipping_recipient, :shipping_address_street_1, :shipping_address_street_2, :shipping_address_city, :shipping_address_state, :shipping_address_zip,
                         :shipping_address_country, :marketing_plan_link, :marketing_copy_message, :contact_phone, :expedite_instructions ]
      )
  end

  def set_project
    @project = Project.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = 'The project you were looking for could not be found.'
      redirect_to projects_path
  end

  def update_current_task
    current_task = @project.current_tasks.where(task_id: params[:submitted_task_id]).first
    unless current_task.nil? || current_task.task.next_task.nil?
      current_task.task_id = current_task.task.next_task.id
      current_task.save
      publish(:update_task, @project, current_task.task)
    end
  end

  def reject_current_task
    current_task = @project.current_tasks.where(task_id: params[:submitted_task_id]).first
    unless current_task.nil? || current_task.task.rejected_task.nil?
      current_task.task_id = current_task.task.rejected_task.id
      current_task.save
      publish(:update_task, @project, current_task.task)
    end
  end

  def team_memberships_params
    params.require(:team_membership).permit(:role_id, :member_id, :percentage)
  end
end
