class ProjectMailer < ActionMailer::Base
  before_action :set_campaign_header

  # Mailgun Campaign ID for tracking Rails Project emails
  CampaignId = 'fb2m3'

  # Override the default from like this:
  # default from: "no-reply@teamtrope.com"

  # loading the roles into a hash table where the symbolized role name is the
  # key and the id is the value
  Roles = Hash[*Role.all.map{ | role | [role.name.downcase.gsub(/ /, "_").to_sym, role.id] }.flatten]


  # Fired whenever a new project is created
  def project_created (project, current_user)
    @project = project
    @current_user = current_user

    genres = []
    @project.genres.all.each { |g| genres.push( g.name ) }

    tokens = {
        'Title' => @project.book_title,
        'Author' => (@project.authors.try(:first).try(:member).nil?) ? 'N/A' : @project.authors.first.member.name,
        'Genre(s)' => genres.join(', '),
        'Imprint' => (@project.try(:imprint).try(:name).nil?) ? 'N/A' : @project.try(:imprint).try(:name),
        'Length' => (@project.try(:page_count).nil?) ? 'N/A' : @project.try(:page_count),
        'Has Pictures or Illustrations' => (@project.try(:has_internal_illustrations) == true) ? 'Yes' : 'No',
        'Previously published' => (@project.try(:previously_published) == true) ? 'Yes' : 'No'
    }

    if(! @project.special_text_treatment.nil?)
      tokens.store('Special Treatment', ("<pre>" + @project.special_text_treatment + "</pre>").html_safe )
    end

    if(! @project.synopsis.nil?)
      tokens.store('Synopsis', ("<pre>" + @project.synopsis + "</pre>").html_safe )
    end

    tokens.store('Submitted By', email_address_link(current_user).html_safe)
    tokens.store('Submitted Date', @project.created_at.strftime("%Y/%m/%d"))

    # Admin From: jennifer.gilbert@booktrope.com - Do we need this?
    admin_subject = "New Project submitted: #{project.book_title}"
    user_subject = "#{@project.book_title} project request received"

    send_email_message('project_created', tokens, get_project_recipient_list(@project, roles: [:author]), user_subject)
    send_email_message('project_created_admin', tokens, admin_project_created_list, admin_subject)
  end

  def import_contract(project, imported_contract_id, current_user)
    @project = project
    @imported_contract = ImportedContract.find(imported_contract_id)
    @current_user = current_user


    tokens = {
      'Contract Type' => ImportedContract::Document_Types.key(@imported_contract.document_type),
      'Contract Date' => @imported_contract.document_date,
      'Signers' => @imported_contract.signers.map(&:name).join(", ")
    }

    subject = "New legal document imported for #{@project.book_title} by #{@current_user.name}"

    send_email_message('import_contract_admin', tokens, admin_contract_import_list, subject)
  end

  def check_imprint(project, current_user)
    @project = project
    @current_user = current_user

    tokens = {
      'Imprint' => project.try(:imprint).try(:name),
      'Paperback ISBN' => project.control_number.try(:paperback_isbn)
    }

    admin_subject = "Imprint and Paperback ISBN from #{@current_user.name} for #{@project.book_title}"

    # The layout of email is the same as edit_control_numbers so we simply pass the subset of tokens that
    # this form collects.
    send_email_message('edit_control_numbers', tokens, admin_edit_control_numbers_list, admin_subject)
  end

  # Control numbers have been updated
  def edit_control_numbers(project, current_user)
    @project = project
    @current_user = current_user

    tokens = {
        'Imprint' => project.try(:imprint).try(:name),
        'eBook Library Price' => project.control_number.try(:ebook_library_price),
        'ASIN'  => project.control_number.try(:asin),
        'Encore ASIN'  => project.control_number.try(:encore_asin),
        'AppleID' => project.control_number.try(:apple_id),
        'Barnes & Noble ID' => project.control_number.try(:bnid),
        'ePub ISBN' => project.control_number.try(:epub_isbn),
        'Hardback ISBN'  => project.control_number.try(:hardback_isbn),
        'Paperback ISBN'  => project.control_number.try(:paperback_isbn)
    }

    admin_subject = "New Control Numbers from #{@current_user.name} for #{@project.book_title}"
    send_email_message('edit_control_numbers', tokens, admin_edit_control_numbers_list, admin_subject)
  end

  # Social Media Marketing has been updated
  def update_social_media_marketing(project, current_user)
    @project = project
    @current_user = current_user

    tokens = {
        'Author Facebook Page' => project.social_media_marketing.try(:author_facebook_page),
        'Author Central Account' => project.social_media_marketing.try(:author_central_account_link),
        'Website Url'  => project.social_media_marketing.try(:website_url),
        'Twitter'  => project.social_media_marketing.try(:twitter),
        'Pintrest' => project.social_media_marketing.try(:pintrest),
        'Goodreads' => project.social_media_marketing.try(:goodreads),
    }

    admin_subject = "New Social Media Marketing links from #{@current_user.name} for #{@project.book_title}"
    send_email_message('update_social_media_marketing', tokens, admin_social_media_marketing_list, admin_subject)
  end

  # Accepted file download terms
  def accepted_download_terms(project, current_user, params)
    @project = project
    @current_user = current_user
    subject = "Accepted Terms"
    recipients = get_project_recipient_list(project) + admin_assets_access_list
    message_template = "accepted_terms"
    send_email_message(message_template, {}, recipients, subject)
  end

  # A new team member has been added to the team
  def accepted_team_member(project, current_user, params)
    @project = project
    @current_user = current_user

    team_membership = params[:project][:team_memberships_attributes]['0']
    role = Role.find(team_membership['role_id'])
    member = User.find(team_membership['member_id'])
    percentage = team_membership['percentage']

    tokens = {
      'Role' => role.try(:name),
      'New Team Member' => member.try(:name),
      'Percentage' => percentage + '%',
      'Effective Date' => "#{params[:accept_member_effective_date][:year]} / #{params[:accept_member_effective_date][:month]} / #{params[:accept_member_effective_date][:day]}"
    }

    user_subject = "Accept Team Member from #{@current_user.name} for #{@project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('accept_team_member', tokens, get_project_recipient_list(@project), user_subject)
    send_email_message('accept_team_member_admin', tokens, admin_accept_team_member_list, admin_subject)
  end

  # Notify Admin that a new 1099 was received
  def received_1099_form(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "1099 Info for #{@current_user.name} received"
    admin_subject = "New 1099 Form Info from #{@current_user.try(:name)} for 1099"

    send_email_message('received_1099', {}, current_user.try(:email), user_subject)
    send_email_message('received_1099_admin', {}, admin_1099_received_list, admin_subject)
  end

  # Sent when the revenue allocation for the project is changed (but not for membership changes)
  def rev_allocation_change(project, current_user, effective_date)
    @project = project
    @current_user = current_user

    # only send notifications to roles that have had a change of percentage.
    roles = []
    @project.team_memberships.each do | tm |
      if tm.previous_changes.has_key? "percentage"
        roles << tm.role.name.downcase.gsub(/ /, "_").to_sym
      end
    end

    tokens = {}
    project.team_memberships.each do |m|
      tokens.store("#{m.member.name} (#{m.role.name})", m.percentage.to_s + "%")
    end

    tokens.store('Effective Date', effective_date)

    tokens['Published'] = 'No'

    if @project.project_grid_table_row.production_task_name == "Production Complete"
      tokens['Published'] = 'Yes'
      tokens['Publication Date'] = @project.published_file.publication_date unless @project.published_file.nil? || @project.published_file.publication_date.nil?
    end

    user_subject = "Revenue Allocation for #{project.book_title}"
    admin_subject = "New Project Revenue Allocation from #{current_user.name} for #{project.book_title}"

    send_email_message('rev_allocation_change', tokens, get_project_recipient_list(@project, roles: roles), user_subject)
    send_email_message('rev_allocation_change_admin', tokens, admin_rev_allocation_change_list, admin_subject)
  end

  def remove_team_member(project, current_user, params)
    @project = project
    @current_user = current_user

    member_id = params[:project][:audit_team_membership_removals_attributes]['0'][:member_id]
    membership = project.team_memberships.find(member_id)
    notified = (params[:project][:audit_team_membership_removals_attributes]['0'][:notified_member] == 'true')

    team_memberships = TeamMembership.new

    reason_key = params[:project][:audit_team_membership_removals_attributes]['0'][:reason]
    reason = (reason_key == 'other') ? params[:team_removal_reason_other_input] : team_memberships.get_removal_reason(reason_key)

    tokens = {
        'Member' => "#{membership.member.name} (#{membership.role.name})",
        'Reason for removal' => reason, # Could be other
        'Notified' => (notified) ? 'Yes' : 'No'
    }

    tokens['Published'] = 'No'

    if @project.project_grid_table_row.production_task_name == "Production Complete"
      tokens['Published'] = 'Yes'
      tokens['Publication Date'] = @project.published_file.publication_date unless @project.published_file.nil? || @project.published_file.publication_date.nil?
    end

    user_subject = "Removal Team Member Request from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('remove_team_member', tokens, get_project_recipient_list(@project, send_submitter: true, excluded_emails: [ membership.member.email ], roles: [:author]), user_subject)
    send_email_message('remove_team_member_admin', tokens, admin_remove_member_request_list, admin_subject)
  end

  # Notify team members & the staff that the original manuscript has been uploaded
  def original_manuscript_uploaded(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Original Manuscript from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('original_manuscript', {}, get_project_recipient_list(@project, roles: [:project_manager, :book_manager, :author]), user_subject)
    send_email_message('original_manuscript_admin', {}, admin_original_manuscript_list, admin_subject)
  end

  def submit_edited_manuscript(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Edited Manuscript Submission for #{project.book_title}"
    admin_subject = "New Submit Edited Manuscript from #{current_user.name} for {project.book_title}"

    send_email_message('submit_edited_manuscript', {}, get_project_recipient_list(@project, roles: [:author, :project_manager, :book_manager, :editor, :proofreader]), user_subject)
    send_email_message('submit_edited_manuscript_admin', {}, admin_edited_manuscript_list, admin_subject)
  end

  def submit_proofread_reviewed_manuscript(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Proofed Manuscript Submission from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    tokens = {}

    send_email_message('submit_proofread_reviewed_manuscript', tokens, get_project_recipient_list(@project, roles: [:project_manager, :author, :proofreader]), user_subject)
    send_email_message('submit_proofread_reviewed_manuscript_admin', tokens, admin_proofread_reviewed_manuscript_list, admin_subject)
  end

  def submit_to_layout(project, current_user, params)
    @project = project
    @current_user = current_user

    subject = "Final Manuscript Submitted to Layout from #{current_user.name} for #{project.book_title}"

    # form page 1
    tokens = {
      'All Acknowledgments, Dedications, Author Notes, etc. that you want included in the front and back of the book are included in this manuscript'  => '&#10004;'.html_safe,
      'Chapter Headings are the way you want them to appear in the final manuscript (e.g. "Chapter One," "Chapter 1", "1", "CHAPTER ONE") and chapter numbering is correct' => '&#10004;'.html_safe,
      'All body text is Palatino Linotype, size 10' => '&#10004;'.html_safe,
      'All chapter headings are Palatino Linotype, size 14 (note: Actual Title and Chapter Heading font will be selected via the “Choose Style” form)' => '&#10004;'.html_safe,
      'All body text is fully justified (excluding text that you wish to be centered, which should be centered)' => '&#10004;'.html_safe,
      'All paragraphs end in hard returns (Enter ¶), not soft returns (Shift + Enter )' => '&#10004;'.html_safe,
      'Indents were created using the Tab key or a Format > Paragraph > First Line rule, not by repeatedly pressing the Spacebar' => '&#10004;'.html_safe,
      'There is a page break inserted between each chapter' => '&#10004;'.html_safe,
      'All tracked changes have been accepted or rejected and all comments have been removed. If tracked changes or comments are included in the document, it will be returned to you for correction, resulting in layout delays' => '&#10004;'.html_safe,
      'Any body text you wish to appear italicized, bolded, or in all caps is treated as such in this document'  => '&#10004;'.html_safe,
    }

    # form page 2
    tokens['Project Type'] = @project.book_type_pretty

    if @project.previously_published == true
      tokens['Previously Published'] = 'Yes'
      tokens['Previously Published Title'] = @project.previously_published_title
      tokens['Previously Published Year'] = @project.previously_published_year
      tokens['Previous Publisher'] = @project.previously_published_publisher
    else
      tokens['Previously Published'] = 'No'
    end

    tokens['Genre'] = @project.genres.distinct.map(&:name).join(",")
    tokens['Imprint'] = (! @project.imprint.nil?) ? @project.try(:imprint).try(:name) : 'N/A'


    # look up if any of the authors on this project have any other book(s)
    # published by booktrope.
    previous_works = Project.includes(:team_memberships)
          .joins(:team_memberships)
          .where("team_memberships.role_id = ? and
              team_memberships.member_id in (?) and
              team_memberships.project_id != ? ",
              Role.find_by_name("Author"),
              @project.authors.map(&:member_id),
              @project.id).distinct

    if previous_works.count > 0

      works_list = "<pre><ul>"
      previous_works.each do | previous_work |
        works_list = works_list + "<li>#{previous_work.book_title}</li>"
      end
      works_list = works_list + "</ul></pre>"

      tokens['Previously Booktrope Published Titles'] = works_list.html_safe
    end

    if !@project.try(:credit_request).nil?
      tokens['Additional Credits Requested'] = "<pre>#{@project.credit_request}</pre>".html_safe
    end

    # form page 3

    tokens['Scene changes are inidcated by:'] = "No Scene Changes"
    unless params['scene_change'].nil?
      tokens['Scene changes are inidcated by:'] = Project::SceneChangeOptions[params['scene_change'].to_i]
    end

    tokens['Are any of your chapters divided into sections with subheadings?'] = (params[:project]['has_sub_chapters'] == 'true') ? 'Yes, and all subheadings are indicated with a larger font size' : 'No'

    tokens['Does your manuscript contain images?'] = (params['does_contain_images'] != '0') ? 'Yes' : 'No'

    if params[:dropbox_link] != ''
      tokens['Images have been uploaded to Dropbox Folder'] = params['dropbox_link']
    end

    if params[:teamtrope_link] != ''
      tokens['Images have been uploaded to Teamtrope Docs Section'] = params['teamtrope_link']
    end

    tokens['Included a TOC for the paperback edition of my book'] = @project.table_of_contents?? 'Yes' : 'No'


    if params[:project]['special_text_treatment'] != ''
      tokens['Sections requiring special treatment:'] = "<pre>#{params[:project]['special_text_treatment']}</pre>".html_safe
    end

    # form page 4
    tokens['Inside Book Title and Chapter font'] = @project.layout.layout_style_choice
    tokens['Left Side Page Header Display - Name'] = @project.layout.page_header_display_name
    tokens['Using pen name'] = (@project.layout.use_pen_name_on_title) ? 'Yes' : 'No'


    if(@project.layout.use_pen_name_on_title)
      tokens['Pen name'] = @project.layout.pen_name
      tokens['Using pen name for copyright'] = (@project.layout.use_pen_name_for_copyright) ? 'Yes' : 'No'
      tokens['Exact name to appear on copyright'] = @project.layout.exact_name_on_copyright
    end

    # form page 5
    if ! @project.target_market_launch_date.nil?
      tokens['Target Market Launch Date'] = @project.target_market_launch_date
    end

    tokens['Manuscript Word Count:'] = params[:project]['proofed_word_count']

    send_email_message('proofread_final_manuscript', tokens, get_project_recipient_list(@project, roles: [:project_manager, :author]), subject)
    send_email_message('proofread_final_manuscript_admin', tokens, admin_submit_to_layout_list, subject)

  end

  # Manuscript submitted by Proof-Reader
  def proofread_final_manuscript(project, current_user, params)
    @project = project
    @current_user = current_user

    subject = ""
    if params[:commit] != 'Update Manuscript'
      tokens = {
        'Content text has been converted to palatino linotype, size 10' => '&#10004;'.html_safe,
        'Any Acknowledgments, Dedication, Author Notes, etc. that I want included are included in this manuscript' => '&#10004;'.html_safe,
        'Any and all tracked changes have been accepted or rejected; Comments have been removed' => '&#10004;'.html_safe,
        'All text is fully justified (text is aligned with both the left and right margin)' => '&#10004;'.html_safe,
        'Chapter Headings are the way I want them to appear in the final manuscript (e.g. "Chapter One," "Chapter 1", "1", "CHAPTER ONE"). Also, I have reviewed and made sure that Chapter Numbering is correct (No missing or duplicated numbers).' => '&#10004;'.html_safe,
        'All editing and stylistic choices (italics, caps) have been made and are final' => '&#10004;'.html_safe,
        'All chapter headings are size 14 font and there is a page break inserted between each chapter' => '&#10004;'.html_safe,
        'I have looked over and approved the delivered proofreading and the content. Nothing more will be added or removed from this document, and no further changes will be made.' => '&#10004;'.html_safe,
        'All narrative breaks/scene changes are indicated with three asterisks (***).' => (params['scene_changes'].nil?) ? 'No' : 'Yes',
        'Does your book contain sub-chapters?' => (params[:project]['has_sub_chapters'] == 'true') ? 'Yes, and all sub-section headers are indicated by increments of increasing font sizes' : 'No',
        'Does your manuscript contain images?' => (params['does_contain_images'] != '0') ? 'Yes' : 'No',
        'Imprint' => (! @project.imprint.nil?) ? @project.try(:imprint).try(:name) : 'N/A',
        'Project Type' => @project.book_type_pretty
      }

      if(@project.previously_published == true)
        tokens.store('Previously Published', 'Yes')
        tokens.store('Previously Published Title', @project.previously_published_title)
        tokens.store('Previously Published Year', @project.previously_published_year)
        tokens.store('Previous Publisher', @project.previously_published_publisher)
      else
        tokens.store('Previously Published', 'No')
      end

      if(!@project.try(:credit_request).nil?)
        tokens.store('Additional Credits Requested', ("<pre>" + @project.credit_request + "</pre>").html_safe )
      end

      if(params[:dropbox_link] != '')
        tokens.store('Images have been uploaded to Dropbox Folder', params['dropbox_link'])
      end

      if(params[:teamtrope_link] != '')
        tokens.store('Images have been uploaded to Teamtrope Docs Section', params['teamtrope_link'])
      end

      if(params[:project]['special_text_treatment'] != '')
        tokens.store('Sections requiring special treatment:', ("<pre>" +params[:project]['special_text_treatment'] + "</pre>").html_safe )
      end

      if(! @project.target_market_launch_date.nil?)
        tokens.store('Target Market Launch Date', @project.target_market_launch_date)
      end

      tokens.store('Manuscript Word Count:', params[:project]['proofed_word_count'])

      subject = "New Submit Final Proofed Document from #{current_user.name} for #{project.book_title} (#{params[:project]['proofed_word_count']} words)"
    else
      subject = "New Verion of Final Proofed Document from #{current_user.name} for #{project.book_title}"
    end

    tokens ||= {}

    send_email_message('proofread_final_manuscript', tokens, get_project_recipient_list(@project, roles: [:project_manager, :author]), subject)
    send_email_message('proofread_final_manuscript_admin', tokens, admin_proofread_final_manuscript_list, subject)
  end

  def edit_layout_style(project, current_user)
    @project = project
    @current_user = current_user

    tokens = {
        'Inside Book Title and Chapter font' => project.layout.layout_style_choice,
        'Left Side Page Header Display - Name' => project.layout.page_header_display_name,
        'Using pen name' => (project.layout.use_pen_name_on_title) ? 'Yes' : 'No',
    }

    if(project.layout.use_pen_name_on_title)
      tokens.store('Pen name', project.layout.pen_name)
      tokens.store('Using pen name for copyright', (project.layout.use_pen_name_for_copyright) ? 'Yes' : 'No')
      tokens.store('Exact name to appear on copyright', project.layout.exact_name_on_copyright)
    end

    user_subject = "Select Layout Style from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('edit_layout_style', tokens, get_project_recipient_list(@project, send_submitter: true, roles: [:none]), user_subject)
    send_email_message('edit_layout_style_admin', tokens, admin_edit_layout_style_list, admin_subject)
  end

  def layout_upload(project, current_user)
    @project = project
    @current_user = current_user
    @layout_notes = project.layout.layout_notes

    user_subject = "Layout Upload from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('layout_upload', {}, get_project_recipient_list(@project, roles: [:author, :project_manager]), user_subject)
    send_email_message('layout_upload', {}, admin_layout_upload_list, admin_subject)
  end

  def layout_approval(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Layout Approved from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('layout_approved', {}, get_project_recipient_list(@project, send_submitter: true, roles: [:none]), user_subject)
    send_email_message('layout_approved_admin', {}, admin_layout_approved_list, admin_subject)
  end

  def update_final_page_count(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Final Page Count from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    tokens = {
      "ISBN" => (@project.control_number.nil? || @project.control_number.paperback_isbn.nil? || @project.control_number.paperback_isbn.try(:empty?))?  "None Provided" : @project.control_number.paperback_isbn,
      "Imprint" => @project.imprint.nil?? "None Provided" : @project.imprint.name,
      "Paperback Price" => "$ #{ @project.publication_fact_sheet.print_price}",
      "Trim Size" => "#{@project.layout.trim_size_w} x #{@project.layout.trim_size_h}"
    }

    send_email_message('final_page_count', tokens, get_project_recipient_list(@project, roles: [:author, :book_manager, :cover_designer, :project_manager]), user_subject)
    send_email_message('final_page_count', tokens, admin_final_page_count_list, admin_subject)
  end

  def cover_concept_upload(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Upload Cover Concept from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('cover_concept_upload', {}, get_project_recipient_list(@project, roles: [:author, :book_manager, :cover_designer, :project_manager]), user_subject)
    send_email_message('cover_concept_upload_admin', {}, admin_cover_concept_upload_list, admin_subject)
  end

  def approve_cover_art(project, current_user, approved)
    @project = project
    @current_user = current_user
    @approved = approved

    user_subject = "Approve Cover Art from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('approve_cover_art', {}, get_project_recipient_list(@project, roles: [:author, :book_manager, :cover_designer, :project_manager]), user_subject)
    send_email_message('approve_cover_art_admin', {}, admin_approve_cover_art_list, admin_subject)
  end

  def request_images(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Request Image from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('request_images', {}, get_project_recipient_list(@project, roles: [:cover_designer, :project_manager]), user_subject)
    send_email_message('request_images', {}, admin_request_images_list, admin_subject)
  end

  def add_stock_cover_image(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Add Image from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('add_stock_cover_image', {}, get_project_recipient_list(@project, roles: [:author, :cover_designer, :project_manager]), user_subject)
    send_email_message('add_stock_cover_image', {}, admin_add_stock_cover_image_list, admin_subject)
  end

  def upload_cover_templates(project, current_user, params)
    @project = project
    @current_user = current_user

    tokens = {
        'Author bio is correct?' => '&#10004;'.html_safe,
        'Book blurb on back is final?' => '&#10004;'.html_safe,
        'ISBN bar code matches ISBN on title page of laid out document?' => '&#10004;'.html_safe,
        'Author name and title are correct on front cover?' => '&#10004;'.html_safe,
        'All fonts are for commercial use and appropriate license(s) have been acquired?' => '&#10004;'.html_safe,
    }

    user_subject = "Upload Cover Templates from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('upload_cover_templates', tokens, get_project_recipient_list(@project, roles: [:author, :book_manager, :cover_designer, :project_manager]), user_subject)
    send_email_message('upload_cover_templates_admin', tokens, admin_upload_cover_templates_list, admin_subject)
  end

  def approve_final_cover(project, current_user, approved)
    @project = project
    @current_user = current_user
    @approved = approved

    user_subject = "Final Cover Approval from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('final_cover_approval', {}, get_project_recipient_list(@project, roles: [:author, :book_manager, :cover_designer, :project_manager]), user_subject)
    send_email_message('final_cover_approval', {}, admin_final_cover_approval_list, admin_subject)
  end

  def artwork_rights_request(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Artwork Rights Request from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('artwork_rights_request', {}, get_project_recipient_list(@project, roles: [:author]), user_subject)
    send_email_message('artwork_rights_request', {}, admin_artwork_rights_request_list, admin_subject)
  end

  def submit_blurb(project, current_user)
    @project = project

    user_subject = "Blurb Submit from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('submit_blurb', {}, get_project_recipient_list(@project, roles: [:author, :book_manager]), user_subject)
    send_email_message('submit_blurb', {}, admin_blurb_submit_list, admin_subject)
  end

  def approve_blurb(project, current_user, approved)
    @project = project
    @approved = approved

    user_subject = "Approve Blurb from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('approve_blurb', {}, get_project_recipient_list(@project, roles: [:author, :book_manager, :project_manager]), user_subject)
    send_email_message('approve_blurb', {}, admin_blurb_approve_list, admin_subject)
  end

  def publication_fact_sheet(project, current_user)
    @project = project
    pfs = project.publication_fact_sheet

    tokens = {
        'Final title' => project.final_title,
        'Author name' => pfs.try(:author_name),
        'Series name' => pfs.try(:series_name),
        'Series number' => pfs.try(:series_number),
        'Book and author description' => ('<pre>' + pfs.try(:description) + '</pre>').html_safe,
        'Author Bio' => ('<pre>' + pfs.try(:author_bio) + '</pre>').html_safe,
        'Endorsements' => ('<pre>' + pfs.try(:endorsements) + '</pre>').html_safe,
        'One line blurb' => pfs.try(:one_line_blurb),
        'ebook price' => '$' + pfs.try(:ebook_price).to_s,
        'BISAC code one' => pfs.try(:bisac_code_one),
        'BISAC code one name' => pfs.try(:bisac_code_name_one),
        'BISAC code two' => pfs.try(:bisac_code_two),
        'BISAC code two name' => pfs.try(:bisac_code_name_two),
        'BISAC code three' => pfs.try(:bisac_code_three),
        'BISAC code three name' => pfs.try(:bisac_code_name_three),
        'Search terms' => ('<pre>' + pfs.try(:search_terms) + '</pre>').html_safe,
        'Age range' => PublicationFactSheet::AGE_RANGES.to_h[pfs.try(:age_range)],
        'Starting Grade Level' => pfs.try(:starting_grade_level),
        'Paperback price' => '$' + pfs.try(:print_price).to_s,
        'Paperback cover' => PublicationFactSheet::COVER_TYPES.to_h[pfs.try(:paperback_cover_type)],
        'Paperback ISBN' => project.control_number.try(:paperback_isbn) || 'None Provided',
        'Epub ISBN' => project.control_number.try(:epub_isbn) || 'None Provided',
        'Page Count' => (project.layout.try(:final_page_count) || project.page_count).to_s,
        'Trim Size' => "#{project.layout.try(:trim_size_w) || '?'} " \
                       "x #{project.layout.try(:trim_size_h) || '?'}",
        'Imprint' => project.imprint.try(:name) || 'None Provided',
    }

    user_subject = "Publication Fact Sheet from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('publication_fact_sheet', tokens, get_project_recipient_list(@project, roles: [:author, :book_manager, :project_manager]), user_subject)
    send_email_message('publication_fact_sheet_admin', tokens, admin_publication_fact_sheet_list, admin_subject)
  end

  def marketing_expense(project, marketing_expense, current_user)
    @project = project
    tokens = {
      "Invoice Due Date" => marketing_expense.invoice_due_date,
      "Marketing Activity Start Date" => marketing_expense.start_date,
      "Marketing Activity End Date" => marketing_expense.end_date,
      "Type of Marketing Activity" => (marketing_expense.expense_type.join(", ") == "Other - Please Describe below")    ? marketing_expense.other_type              : marketing_expense.expense_type.join(", "),
      "Marketing Service Provider" => (marketing_expense.service_provider.join(", ") == "Other - Please specify below") ? marketing_expense.other_service_provider :  marketing_expense.service_provider.join(", "),
      "Cost" => "$#{marketing_expense.cost}",
      "Other Information" => ("<pre>#{marketing_expense.other_information}</pre>").html_safe
    }

    admin_subject = "New Marketing Expense from #{current_user.name} for #{project.book_title}"
    send_email_message('marketing_expense_admin', tokens, admin_marketing_expense_list, admin_subject)

  end

  def production_expense(project, production_expense, current_user)
    @project = project
    tokens = {
      'Total quantity ordered' => production_expense[:total_quantity_ordered],
      'Total cost of order' => '$' + production_expense[:total_cost].to_s,
      'Quantity treated as complimentary' => production_expense[:complimentary_quantity],
      'Value of complimentary copies' => '$' + production_expense[:complimentary_cost].to_s,
      'Quantity treated as author advance' => production_expense[:author_advance_quantity],
      'Value treated as author advance' => '$' + production_expense[:author_advance_cost].to_s,
      'Quantity treated as purchased copies' => production_expense[:purchased_quantity],
      'Total cost of purchased copies' => '$' + production_expense[:purchased_cost].to_s,
      'Value of purchased copies to invoice via Paypal' => production_expense[:paypal_invoice_amount],
      'Explanation of how value of purchased copies was calculated' => ('<pre>' + production_expense[:calculation_explanation] + '</pre>').html_safe,
      'Quantity for marketing purposes' => production_expense[:marketing_quantity],
      'Total Cost of Marketing Copies' => '$' + production_expense[:marketing_cost].to_s,
      'Addtional costs' => ProductionExpense::ADDITIONAL_COSTS.to_h[production_expense.additional_costs.join],
      'Total of additional costs to be allocated to teams' => '$' + production_expense[:additional_team_cost].to_s,
      'Total of additional costts to be absorbed by Booktrope' => '$' + production_expense[:additional_booktrope_cost].to_s,
      'Date costs should be allocated against revenue' => production_expense[:effective_date]
    }

    user_subject = "Production Expense from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('production_expense', tokens, get_project_recipient_list(@project, roles: [:none]), user_subject)
    send_email_message('production_expense_admin', tokens, admin_production_expense_list, admin_subject)

  end

  def final_manuscript(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Final Manuscript from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('final_manuscript', {}, get_project_recipient_list(@project, roles: [:none]), user_subject)
    send_email_message('final_manuscript', {}, admin_final_manuscript_list, admin_subject)
  end

  def publish_book(project, current_user)
    @project = project
    @current_user = current_user
    imprint_text = (@project.try(:imprint).try(:name).nil?) ? '' : @project.try(:imprint).try(:name)
    user_subject = "#{imprint_text} Book #{project.book_title} is Published! (submitted by #{current_user.name})"
    admin_subject = "New " + user_subject


    send_email_message('publish_book', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('publish_book', {}, admin_publish_book_list, admin_subject)
  end

  def media_kit(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Media Kit from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('media_kit', {}, get_project_recipient_list(@project, roles: [:author, :book_manager]), user_subject)
    send_email_message('media_kit', {}, admin_media_kit_list, admin_subject)
  end

  def ebook_only_incentive(project, current_user)
    @project = project
    @current_user = current_user

    tokens = {
      "Title" => @project.ebook_only_incentive.title,
      "Author" => @project.ebook_only_incentive.author_name,
      "Book Manager" => @project.ebook_only_incentive.book_manager,
      "Series Name" => @project.try(:publication_fact_sheet).try(:series_name),
      "Series Number" => @project.try(:publication_fact_sheet).try(:series_number),
      "ISBN" => @project.ebook_only_incentive.isbn,
      "Imprint" => @project.ebook_only_incentive.imprint,
      "Publication Date" => @project.ebook_only_incentive.publication_date,
      "Retail Price" => @project.ebook_only_incentive.retail_price,
      "Blurb" => @project.ebook_only_incentive.blurb,
      "Website One" => @project.ebook_only_incentive.website_one,
      "Website Two" => !@project.ebook_only_incentive.website_two.nil?? @project.ebook_only_incentive.website_two : "N/A",
      "Website Three" => !@project.ebook_only_incentive.website_three.nil?? @project.ebook_only_incentive.website_three : "N/A",
      "Praise" => @project.ebook_only_incentive.praise,
      "Category One" => @project.ebook_only_incentive.category_one,
      "Category Two" => @project.ebook_only_incentive.category_two
    }

    user_subject = "eBook Only Incentive from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('ebook_only_incentive', tokens, get_project_recipient_list(@project, roles: [:author, :book_manager]), user_subject)
    send_email_message('ebook_only_incentive', tokens, admin_ebook_only_incentive_list, admin_subject)
  end

  def new_netgalley_submission(project, current_user)

    @project = project
    @current_user = current_user

    tokens = {
      'Title' => @project.netgalley_submission.title,
      'Author' => @project.netgalley_submission.author_name,
      'Book Manager' => @project.netgalley_submission.book_manager,
      'Series Name' => @project.try(:publication_fact_sheet).try(:series_name),
      'Series Number' => @project.try(:publication_fact_sheet).try(:series_number),
      'ISBN' => @project.netgalley_submission.isbn,
      'Imprint' => @project.netgalley_submission.imprint,
      'Publication Date' => @project.netgalley_submission.publication_date,
      'Retail Price' => @project.netgalley_submission.retail_price,
      'Blurb' => @project.netgalley_submission.blurb,
      'Website One' => @project.netgalley_submission.website_one,
      'Website Two' => !@project.netgalley_submission.website_two.nil?? @project.netgalley_submission.website_two : 'N/A',
      'Website Three' => !@project.netgalley_submission.website_three.nil?? @project.netgalley_submission.website_three : 'N/A',
      'Praise' => @project.netgalley_submission.praise,
      'Category One' => @project.netgalley_submission.category_one,
      'Category Two' => @project.netgalley_submission.category_two,
      'Does not qualify for Mkt expense, will personally cover cost' => (@project.netgalley_submission.personal_submission) ? 'Yes': 'No'
    }

    if(@project.netgalley_submission.personal_submission)
      tokens.store('Invoice Paypal Email', @project.netgalley_submission.paypal_email)
    end

    user_subject = "Netgalley Submission from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('new_netgalley_submission', tokens, get_project_recipient_list(@project, roles: [:author, :book_manager]), user_subject)
    send_email_message('new_netgalley_submission', tokens, admin_new_netgalley_submission_list, admin_subject)
  end

  def blog_tour(project, current_user)
    @project = project
    @current_user = current_user

    blog_tour = @project.blog_tours.last

    tokens = {
        'Tour Cost'         => "$" + blog_tour.cost.to_s,
        'Tour Service Name' => blog_tour.blog_tour_service,
        'Type'              => blog_tour.tour_type,
        '# Stops'           => blog_tour.number_of_stops,
        'Tour Start'        => blog_tour.start_date.to_s,
        'Tour End'          => blog_tour.end_date.to_s
    }
    user_subject = "Blog Tour from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('blog_tour', tokens, get_project_recipient_list(@project, roles: [:author, :book_manager]), user_subject)
    send_email_message('blog_tour', tokens, admin_blog_tour_list, admin_subject)
  end

  def price_promotion(project, current_user)
    @project = project
    @current_user = current_user

    promo = @project.price_change_promotions.last

    return unless !promo.nil?

    tokens = {}

    # All types use these values

    # converting Array of Arrays into a hash per stackoverflow
    # http://stackoverflow.com/questions/39567/what-is-the-best-way-to-convert-an-array-to-a-hash-in-ruby
    tokens.store('Promotion Type', Hash[*PriceChangePromotion::PROMOTION_TYPES.flatten(1)][promo.type.first])
    tokens.store('Start Date', promo.start_date)

    case promo.type.first
      when 'temporary_force_free'
        # Temporary iTunes/Force free
        tokens.store('End Date', promo.end_date)
        tokens.store('Price after promo', '$' + promo.price_after_promotion.to_s)
      when 'temporary_price_drop'
        tokens.store('Promotion Price', '$' + promo.price_promotion.to_s)
        tokens.store('End Date', promo.end_date)
        tokens.store('Price after promo', '$' + promo.price_after_promotion.to_s)
        # Sites
        promo.sites.each do | site |
          tokens.store(PriceChangePromotion::SITES.to_h[site], '&#10007;'.html_safe)
        end

      when 'permanent_force_free'
        # Nothing more
      when 'permanent_price_drop'
        tokens.store('Promotion Price', '$' + promo.price_promotion.to_s)
    end

    user_subject = "Free/Price Promo from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('price_promotion', tokens, get_project_recipient_list(@project, roles: [:author, :book_manager]), user_subject)
    send_email_message('price_promotion', tokens, admin_price_promo_list, admin_subject)
  end

  def print_corner_request(project, current_user)
    @project = project
    @current_user = current_user
    pc = project.print_corners.last

    tokens = {
        'Submitted By' => User.find(pc.user_id).name
    }

    tokens.store('Order Type', 'Author Copies')
    tokens.store('First Order', (project.print_corners.size <= 1) ? 'Yes' : 'No')
    tokens.store('Quantity', pc.quantity)
    tokens.store('Ship to Name', pc.shipping_recipient)
    tokens.store('Phone Contact', pc.contact_phone)
    tokens.store('Address 1', pc.shipping_address_street_1)
    tokens.store('Address 2', pc.shipping_address_street_2)
    tokens.store('City', pc.shipping_address_city)
    tokens.store('State/Province/Region', pc.shipping_address_state)
    tokens.store('Zip', pc.shipping_address_zip)
    tokens.store('Country', pc.shipping_address_country)
    tokens.store('Email', email_address_link(current_user).html_safe)

    user_subject = "Paperback Order from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('print_corner', tokens, get_project_recipient_list(@project, send_submitter: true, roles: [:author]), user_subject)
    send_email_message('print_corner_admin', tokens, admin_print_corner_list, admin_subject)
  end

  # User has requested Adam set up an e-Store
  def print_corner_estore_request(project, current_user)
    @project = project
    @current_user = current_user
    user_subject = "Paperback e-Store Request from #{current_user.name} for #{project.book_title}"
    admin_subject = "New " + user_subject

    send_email_message('print_corner_estore_request', {}, get_project_recipient_list(@project, send_submitter: true, roles: [:author]), user_subject)
    send_email_message('print_corner_estore_request_admin', {}, admin_print_corner_list, admin_subject)
  end

  def kdp_select_enrollment(project, current_user)
    @project = project
    authors = []
    @project.authors.each{ |a| authors.push(a.member.name) }

    tokens = {
        'Title' => @project.book_title,
        'Author(s)' => authors.join(', '),
        'Enrollment Date' => @project.kdp_select_enrollment.enrollment_date,
        'Submitted by' => current_user.name,
    }

    user_subject = "KDP Select Enrollment Submitted for #{project.book_title}"

    send_email_message('kdp_select_enrollment', tokens, get_project_recipient_list(@project, send_submitter: true, roles: [:author, :book_manager]), user_subject)
    send_email_message('kdp_select_enrollment', tokens, admin_kdp_select_enrollment_list, user_subject)
  end

  def prefunk_enrollment(project, current_user)
    @project = project
    tokens = {}

    pgtr = ProjectGridTableRow.find_by_project_id(project.id)
    pgtr_scribd_hash = pgtr.generate_scribd_export_hash

    Constants::ScribdCsvHeaderHash.keys.each do | key |
      tokens[Constants::ScribdCsvHeaderHash[key]] = pgtr_scribd_hash[key]
    end

    user_subject = "Prefunk Enrollment Submitted for #{project.book_title}"

    send_email_message('prefunk_enrollment', tokens, get_project_recipient_list(@project, send_submitter: true, roles: [:author, :book_manager]), user_subject)
    send_email_message('prefunk_enrollment', tokens, admin_prefunk_enrollment_list, user_subject)
  end

  def kdp_select_update(project, current_user)
    @project = project
    authors = []
    @project.authors.each{ |a| authors.push(a.member.name) }
    kdp = @project.kdp_select_enrollment

    tokens = {
        'Title' => @project.book_title,
        'Author(s)' => authors.join(', '),
        'Submitted by' => current_user.name,
        'Update Requested' => kdp.update_type.gsub(/_/, ' ').split.map(&:capitalize).join(' ')
    }

    if kdp.update_type == 'free_book_promo'
      if ! kdp.update_data['number_date_ranges'].nil?
        max = kdp.update_data['date_ranges'].count
        for date_number in 1..max do
          dates = kdp.update_data['date_ranges'][date_number -1]
          tokens.store(
             "Date Range #{date_number}",
             "#{dates['start_date']} to #{dates['end_date']}"
          )
        end
      end
    elsif kdp.update_type == 'countdown_deal'
      if ! kdp.update_data.nil? && kdp.update_data.count > 0
        kdp.update_data.each do |key,val|
          tokens.store(key.gsub(/_/, ' ').capitalize, val)
        end
      end
    end

    user_subject = "KDP Select Update from #{current_user.name} for #{project.book_title}"

    send_email_message('kdp_select_update', tokens, get_project_recipient_list(@project, send_submitter: true, roles: [:author, :book_manager]), user_subject)
    send_email_message('kdp_select_update', tokens, admin_kdp_select_update_list, user_subject)
  end

  def kdp_withdraw_enrollment(project, current_user)
    @project = project
    tokens = {
        'Title' => @project.final_title,
        'Withdrawal Date' => DateTime.now.strftime('%F %T %Z'),
        'Withdrawn by' => current_user.name,
    }

    user_subject = "KDP Select Withdrawal Submitted for #{project.book_title}"

    send_email_message('kdp_select_withdraw', tokens, get_project_recipient_list(@project, send_submitter: true, roles: [:author, :book_manager]), user_subject)
    send_email_message('kdp_select_withdraw', tokens, admin_kdp_select_enrollment_list, user_subject)
  end

  def rights_back_request(project)
    @project = project
    @request = project.rights_back_request
    pgtr = project.project_grid_table_row

    tokens = {
      'Title' => @request.title,
      'Author' => @request.author,
      'Imprint' => project.try(:imprint).try(:name),
      'Publication Date' => project.try(:published_file).try(:publication_date),
      'Reason for leaving' => @request.reason,
      'This title has been proofed' => (@request.proofed) ? 'Yes' : 'No',
      'This title has been edited' => (@request.edited) ? 'Yes' : 'No',
      'This title has been published' => (@request.published) ? 'Yes' : 'No',
      'Production Task Name' => pgtr.production_task_name,
      'Production Task Last Update' => pgtr.production_task_last_update,
      'Design Task Name' => pgtr.design_task_name,
      'Design Task Last Update' => pgtr.design_task_last_update,
      'Marketing Task Name' => pgtr.marketing_task_name,
      'Marketing Task Last Update' => pgtr.marketing_task_last_update,
    }

    project.team_memberships.each do |m|
      tokens.store("Role: #{m.role.name}", "#{m.member.display_name} (#{m.percentage}%)")
    end

    tokens.store('Total Allocation', project.total_team_percent_allocation.to_s + "%")

    send_email_message('rights_back_request', tokens, admin_rights_back_request_list, "Rights Back Request for #{@request.title}")
  end

  def bookbub_submission(project, current_user)
    @project = project
    @current_user = current_user
    bookbub = project.bookbub_submissions.last
    tokens = {
        'Enrollment Date' => bookbub.enrollment_date.strftime("%Y/%m/%d"),
        'Author Name' => bookbub.author,
        'Book Title' => bookbub.title,
        'Imprint' => project.try(:imprint).try(:name),
        'Genre' => project.try(:genres).try(:first).try(:name),
        'ASIN' => bookbub.asin,
        'ASIN Linked URL' => bookbub.asin_link,
        'Current price' => bookbub.current_price,
        '# of Stars' => bookbub.num_stars,
        '# of Reviews' => bookbub.num_reviews,
        'Has this title had a Bookbub in the past 6 months?' => 'No',
        'Has this author had a Bookbub feature in the past 30 days?' => 'No',
        'How many pages does the title have?' => bookbub.num_pages
    }

    subject = "Bookbub Submission Request for #{project.title}"

    send_email_message('bookbub_submission', tokens, get_project_recipient_list(@project, send_submitter: true, roles: [:author, :book_manager]), subject)
    send_email_message('bookbub_submission_admin', tokens, admin_bookbub_submission_request_list, subject)
  end

  private

  # Generates a link for an email address for a User
  def email_address_link user
    "<a href=\"mailto:#{user.email}\">#{user.name} <#{user.email}></a>"
  end

  # Generic email send pattern that just passes a simple hash table
  def send_email_message (template_name, message_tokens, recipient_list, subject)
    recipient_list = Array(recipient_list) unless recipient_list.is_a?(Array)

    puts recipient_list

    @message_tokens = message_tokens

    recipient_list.each do |recipient|
      mail( to: recipient,
            subject: subject,
            template_name: template_name
      ).deliver
    end
  end

  ## Recipient Lists Below

  # Here might be a good place to intercept the recipient based on their preferences, though we'd
  # need to know the message type.

  # valid options are excluded_emails and roles
  # excluded_emails: (Array) list of emails to filter out of the recipient list
  # roles: (Array) list of roles to send the email to

  #def get_project_recipient_list(project, excluded_emails = Array::[], *roles)
  def get_project_recipient_list(project, **options)
    list = []

    role_keys = options[:roles]
    role_keys ||= Roles.keys # default to all if no roles are passed
    send_submitter = options[:send_submitter]
    send_submitter ||= false
    excluded_emails = options[:excluded_emails]
    excluded_emails ||= []

    role_values = Roles.values_at *role_keys # if :none is passed then values_at will return an empty array

    # If current_user is set, attempt to add them to the recipient list
    if send_submitter
      if ! @current_user.nil?
        list << "#{@current_user.name} <#{@current_user.email}>"
      else
        called_by =  caller[0][/`.*'/][1..-2]
        Rails.logger.error "No current_user defined and send_submitter is true!  Called from #{called_by}"
      end
    end

    project.team_memberships.where(role_id: role_values).each do  |m|
      if excluded_emails.include?(m.member.email)
        next
      end
      list << "#{m.member.name} <#{m.member.email}>"
    end
    list.uniq
  end

    # Used for Project Created updates to Admin
  def admin_project_created_list
    %w( tt_project_created_list@booktrope.com )
  end

  # Notify for a member removal request
  def admin_remove_member_request_list
    %w( tt_remove_member_request_list@booktrope.com )
  end

  # Used when a new team member is added
  def admin_accept_team_member_list
    %w( tt_accept_team_member_list@booktrope.com )
  end

  # The original manuscript has been uploaded
  def admin_original_manuscript_list
    %w( tt_original_manuscript_list@booktrope.com )
  end

  # Used for Control Number updates
  def admin_edit_control_numbers_list
    %w( tt_edit_control_numbers_list@booktrope.com )
  end

  def admin_social_media_marketing_list
    %w( tt_add_author_links_list@booktrope.com )
  end

  # Notify Payroll list of a new 1099 in Box
  def admin_1099_received_list
    %w( tt_1099_received_list@booktrope.com )
  end

  # Notify of an allocation change
  def admin_rev_allocation_change_list
    %w( tt_rev_allocation_change_list@booktrope.com )
  end

  # Notifications for when a user uploads an edited manuscript
  def admin_edited_manuscript_list
    %w( tt_edited_manuscript_list@booktrope.com )
  end

  # A new stock cover image has been uploaded
  def admin_add_stock_cover_image_list
    %w( tt_add_stock_cover_image_list@booktrope.com )
  end

  # The layout has been uploaded
  def admin_layout_upload_list
    %w( tt_layout_upload_list@booktrope.com )
  end

  # The final page count has been updated
  def admin_final_page_count_list
    %w( tt_final_page_count_list@booktrope.com )
  end

  # Images have been requested
  def admin_request_images_list
    %w( tt_request_images_list@booktrope.com )
  end

  def admin_proofread_reviewed_manuscript_list
    %w( tt_first_pass_edit_list@booktrope.com )
  end

  # The proofed manuscript has been uploaded
  def admin_proofread_final_manuscript_list
    %w( tt_proofed_manuscript_list@booktrope.com )
  end

  def admin_submit_to_layout_list
    %w( tt_submit_to_layout_list@booktrope.com )
  end

  # The layout style has been selected
  def admin_edit_layout_style_list
    %w( tt_edit_layout_style_list@booktrope.com )
  end

  # The layout has been approved
  def admin_layout_approved_list
    %w( tt_layout_approved_list@booktrope.com )
  end

  # The Cover Concept has been uploaded
  def admin_cover_concept_upload_list
    %w( tt_cover_concept_upload_list@booktrope.com )
  end

  # The cover art has been approved
  def admin_approve_cover_art_list
    %w( tt_approve_cover_art_list@booktrope.com )
  end

  def admin_upload_cover_templates_list
    %w( tt_upload_cover_templates_list@booktrope.com )
  end

  # The Final Cover approved
  def admin_final_cover_approval_list
    %w( tt_final_cover_approval_list@booktrope.com )
  end

  def admin_artwork_rights_request_list
    %w( tt_artwork_rights_request_list@booktrope.com )
  end

  def admin_blurb_submit_list
    %w( tt_blurb_submit_list@booktrope.com )
  end

  def admin_blurb_approve_list
    %w( tt_blurb_approve_list@booktrope.com )
  end

  def admin_publication_fact_sheet_list
    %w( tt_publication_fact_sheet_list@booktrope.com )
  end

  def admin_final_manuscript_list
    %w( tt_final_manuscript_list@booktrope.com )
  end

  def admin_publish_book_list
    %w( tt_publish_book_list@booktrope.com )
  end

  def admin_media_kit_list
    %w( tt_media_kit_list@booktrope.com )
  end

  def admin_ebook_only_incentive_list
    %w( tt_netgalley_ebook_list@booktrope.com )
  end

  def admin_new_netgalley_submission_list
    %w( tt_netgalley_list@booktrope.com )
  end

  def admin_blog_tour_list
    %w( tt_blog_tour_list@booktrope.com )
  end

  def admin_price_promo_list
    %w( tt_price_promo_list@booktrope.com )
  end

  def admin_print_corner_list
    %w( tt_print_corner_list@booktrope.com )
  end

  def admin_marketing_expense_list
    %w( tt_marketing_expense_list@booktrope.com )
  end

  def admin_production_expense_list
    %w( tt_production_expense_list@booktrope.com )
  end

  def admin_kdp_select_enrollment_list
    %w( tt_kdp_select_enrollment_list@booktrope.com )
  end

  def admin_kdp_select_update_list
    %w( tt_kdp_select_update_list@booktrope.com )
  end

  def admin_prefunk_enrollment_list
    %w( tt_prefunk_enrollment_list@booktrope.com )
  end

  def admin_rights_back_request_list
    %w( tt_rights_back_request@booktrope.com )
  end

  def admin_bookbub_submission_request_list
    %w( tt_bookbub_submissions@booktrope.com )
  end

  def admin_contract_import_list
    %w( tt_legal_document_import_list@booktrope.com )
  end

  def admin_assets_access_list
    %w( tt_assets_access_list@booktrope.com )
  end

  # Set the campaign header for MailGun tracking
  def set_campaign_header
    if !@campaign_id.nil?
      campaign = @campaign_id
    else
      campaign = CampaignId
    end

    headers['X-Mailgun-Campaign-Id'] = campaign
  end
end
