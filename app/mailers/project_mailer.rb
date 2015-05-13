class ProjectMailer < ActionMailer::Base
  before_action :set_campaign_header

  # Mailgun Campaign ID for tracking Rails Project emails
  CampaignId = 'fb2m3'

  # Override the default from like this:
  # default from: "no-reply@teamtrope.com"

  # Fired whenever a new project is created
  def project_created (project, current_user)
    @project = project
    @current_user = current_user
    tokens = {
        'Title' => @project.title,
        'Author' => (@project.authors.try(:first).try(:member).nil?) ? 'N/A' : @project.authors.first.member.name,
        'Genre'  => (@project.genres.try(:first).try(:name).nil?) ? 'N/A' : @project.genres.first.name
    }
    # Admin From: jennifer.gilbert@booktrope.com - Do we need this?
    admin_subject = "New Project submitted: #{project.title}"
    user_subject = "#{@project.title} project request received"

    send_email_message('project_created_admin', tokens, admin_project_created_list, admin_subject)
    send_email_message('project_created', tokens, @current_user.email, user_subject)
  end

  # Fired during Status Updates - Conditional logic sends an admin email if they have questions
  def project_status_update(project, current_user)
    @project = project
    @current_user = current_user

    tokens = {
        'Type' => @project.status_updates.try(:last).try(:type),
        'Status' => @project.status_updates.try(:last).try(:status)
    }

    # Admins get an email if there's a question as part of the update
    if(@project.status_updates.try(:last).try(:type) == 'question')
      admin_subject = "New Update Project Status from #{@current_user.name} for #{@project.title}"
      send_email_message('project_status_update_admin', tokens, admin_status_update_list, admin_subject)
    end

    user_subject = "Update Project Status from #{@current_user.name} for #{@project.title}"
    send_email_message('project_status_update', tokens, get_project_recipient_list(@project), user_subject)
  end

  # Control numbers have been updated
  def edit_control_numbers(project, current_user)
    @project = project
    @current_user = current_user

    tokens = {
        'Imprint' => project.control_number.try(:imprint),
        'eBook Library Price' => project.control_number.try(:ebook_library_price),
        'ASIN'  => project.control_number.try(:asin),
        'AppleID' => project.control_number.try(:apple_id),
        'ePub ISBN' => project.control_number.try(:epub_isbn),
        'Hardback ISBN'  => project.control_number.try(:hardback_isbn),
        'Paperback ISBN'  => project.control_number.try(:paperback_isbn)
    }

    admin_subject = "New Control Numbers from #{@current_user.name} for #{@project.title}"
    user_subject = "Control Numbers from  #{@current_user.name} for #{@project.title}"

    send_email_message('edit_control_numbers', tokens, get_project_recipient_list(@project), user_subject)
    send_email_message('edit_control_numbers', tokens, admin_edit_control_numbers_list, admin_subject)
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
      'Effective Date' => "#{params[:effective_date][:year]} / #{params[:effective_date][:month]} / #{params[:effective_date][:day]}"
    }

    user_subject = "Accept Team Member from #{@current_user.name} for #{@project.title}"
    admin_subject = "New "" + user_subject"

    send_email_message('accept_team_member', tokens, get_project_recipient_list(@project), user_subject)
    send_email_message('accept_team_member_admin', tokens, admin_1099_received_list, admin_subject)
  end

  # Notify Admin that a new 1099 was received
  def received_1099_form(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "1099 Info for #{@current_user.name} received"
    admin_subject = "New 1099 Form Info from #{@current_user.try(:name)} for 1099"

    send_email_message('received_1099', {}, current_user.try(:email), user_subject)
    send_email_message('received_1099_admin', {}, admin_accept_team_member_list, admin_subject)
  end

  # Sent when the revenue allocation for the project is changed (but not for membership changes)
  def rev_allocation_change(project, current_user, effective_date)
    @project = project
    @current_user = current_user

    tokens = {}
    project.team_memberships.each do |m|
      tokens.store("#{m.member.name} (#{m.role.name})", m.percentage.to_s + "%")
    end

    tokens.store('Effective Date', effective_date)

    user_subject = "Revenue Allocation for #{project.title}"
    admin_subject = "New Project Revenue Allocation from #{current_user.name} for #{project.title}"

    send_email_message('rev_allocation_change', tokens, get_project_recipient_list(@project), user_subject)
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

    user_subject = "Removal Team Member Request from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('remove_team_member', tokens, get_project_recipient_list(@project, [ membership.member.email ]), user_subject)
    send_email_message('remove_team_member_admin', tokens, admin_rev_allocation_change_list, admin_subject)
  end

  # Notify team members & the staff that the original manuscript has been uploaded
  def original_manuscript_uploaded(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Original Manuscript from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('original_manuscript', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('original_manuscript_admin', {}, admin_original_manuscript_list, admin_subject)
  end

  def submit_edited_manuscript(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Edited Manuscript Submission for #{project.title}"
    admin_subject = "New Submit Edited Manuscript from #{current_user.name} for {project.title}"

    send_email_message('submit_edited_manuscript', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('submit_edited_manuscript_admin', {}, admin_original_manuscript_list, admin_subject)
  end

  # Manuscript submitted by Proof-Reader
  def proofed_manuscript(project, current_user, params)
    @project = project
    @current_user = current_user

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
      'Does your manuscript contain images?' => (params['does_contain_images'] != '0') ? 'Yes' : 'No'
    }

    if(params[:dropbox_link] != '')
      tokens.store('Images have been uploaded to Dropbox Folder', params['dropbox_link'])
    end

    if(params[:teamtrope_link] != '')
      tokens.store('Images have been uploaded to Teamtrope Docs Section', params['teamtrope_link'])
    end

    if(params[:project]['special_text_treatment'] != '')
      tokens.store('Sections requiring special treatment:', ("<pre>" +params[:project]['special_text_treatment'] + "</pre>").html_safe )
    end

    tokens.store('Manuscript Word Count:', params[:project]['proofed_word_count'])

    subject = "New Submit Final Proofed Document from #{current_user.name} for #{project.title} (#{params[:project]['proofed_word_count']} words)"

    send_email_message('proofed_manuscript', tokens, get_project_recipient_list(@project), subject)
    send_email_message('proofed_manuscript_admin', tokens, admin_proofed_manuscript_list, subject)
  end


  # Marketing Release Date
  def marketing_release_date(project, current_user, release_date)
    @project = project
    @current_user = current_user
    @marketing_release_date = release_date

    user_subject = "Release Date from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('marketing_release_date', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('marketing_release_date_admin', {}, admin_marketing_release_date_list, admin_subject)
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

    user_subject = "Select Layout Style from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('edit_layout_style', tokens, get_project_recipient_list(@project), user_subject)
    send_email_message('edit_layout_style_admin', tokens, admin_edit_layout_style_list, admin_subject)
  end

  def layout_upload(project, current_user)
    @project = project
    @current_user = current_user
    @layout_notes = project.layout.layout_notes

    user_subject = "Layout Upload from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('layout_upload', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('layout_upload', {}, admin_layout_upload_list, admin_subject)
  end

  def layout_approval(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Layout Approved from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('layout_approved', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('layout_approved_admin', {}, admin_layout_approved_list, admin_subject)
  end

  def update_final_page_count(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Final Page Count from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('final_page_count', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('final_page_count', {}, admin_final_page_count_list, admin_subject)
  end

  def cover_concept_upload(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Upload Cover Concept from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('cover_concept_upload', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('cover_concept_upload_admin', {}, admin_cover_concept_upload_list, admin_subject)
  end

  def approve_cover_art(project, current_user, approved)
    @project = project
    @current_user = current_user
    @approved = approved

    user_subject = "Approve Cover Art from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('approve_cover_art', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('approve_cover_art_admin', {}, admin_approve_cover_art_list, admin_subject)
  end

  def request_images(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Request Image from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('request_images', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('request_images', {}, admin_request_images_list, admin_subject)
  end

  def add_stock_cover_image(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Add Image from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('add_stock_cover_image', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('add_stock_cover_image', {}, admin_add_stock_cover_image_list, admin_subject)
  end

  def upload_cover_templates(project, current_user, params)
    @project = project
    @current_user = current_user

    tokens = {
        'Author bio is correct?' => '&#10004;'.html_safe,
        'Book blurb on back is final?' => '&#10004;'.html_safe,
        'ISBN bar code matches ISBN on title page of laid out document?' => '&#10004;'.html_safe,
        'Author name and title are correct on front cover?' => '&#10004;'.html_safe
    }

    user_subject = "Upload Cover Templates from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('upload_cover_templates', tokens, get_project_recipient_list(@project), user_subject)
    send_email_message('upload_cover_templates', tokens, admin_upload_cover_templates_list, admin_subject)
  end

  def artwork_rights_request(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Artwork Rights Request from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('artwork_rights_request', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('artwork_rights_request', {}, admin_artwork_rights_request_list, admin_subject)
  end

  def submit_blurb(project, current_user)
    @project = project

    user_subject = "Blurb Submit from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('submit_blurb', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('submit_blurb', {}, admin_blurb_submit_list, admin_subject)
  end

  def approve_blurb(project, current_user, approved)
    @project = project
    @approved = approved

    user_subject = "Approve Blurb from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('approve_blurb', {}, get_project_recipient_list(@project), user_subject)
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
        'Print price' => '$' + pfs.try(:print_price).to_s,
        'ebook price' => '$' + pfs.try(:ebook_price).to_s,
        'BISAC code one' => pfs.try(:bisac_code_one),
        'BISAC code two' => pfs.try(:bisac_code_two),
        'BISAC code three' => pfs.try(:bisac_code_three),
        'Search terms' => ('<pre>' + pfs.try(:search_terms) + '</pre>').html_safe,
        'Age range' => PublicationFactSheet::AGE_RANGES.to_h[pfs.try(:age_range)],
        'Paperback cover' => PublicationFactSheet::COVER_TYPES.to_h[pfs.try(:paperback_cover_type)]
    }

    user_subject = "Publication Fact Sheet from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('publication_fact_sheet', tokens, get_project_recipient_list(@project), user_subject)
    send_email_message('publication_fact_sheet_admin', tokens, admin_publication_fact_sheet_list, admin_subject)
  end

  def final_manuscript(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Final Manuscript from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('final_manuscript', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('final_manuscript', {}, admin_final_manuscript_list, admin_subject)
  end

  def publish_book(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Publish Book from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('publish_book', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('publish_book', {}, admin_publish_book_list, admin_subject)
  end

  def media_kit(project, current_user)
    @project = project
    @current_user = current_user

    user_subject = "Media Kit from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('media_kit', {}, get_project_recipient_list(@project), user_subject)
    send_email_message('media_kit', {}, admin_media_kit_list, admin_subject)
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
    user_subject = "Blog Tour from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('blog_tour', tokens, get_project_recipient_list(@project), user_subject)
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

    user_subject = "Free/Price Promo from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('price_promotion', tokens, get_project_recipient_list(@project), user_subject)
    send_email_message('price_promotion', tokens, admin_price_promo_list, admin_subject)
  end

  def print_corner_request(project, current_user)
    @project = project
    pc = project.print_corners.last

    tokens = {
        'Submitted By' => User.find(pc.user_id).name
    }

    case pc.order_type
      when 'author_copies'
        tokens.store('Order Type', 'Author Copies')
        tokens.store('First order?', ((pc.first_order == true) ? 'Yes' : 'No'))
        tokens.store('Additional copies?', ((pc.additional_order == true) ? 'Yes' : 'No'))
        tokens.store('Over 125 copies?', ((pc.over_125 == true) ? 'Yes' : 'No'))
        tokens.store('Agreed to Billing Terms', ((pc.billing_acceptance == true) ? 'Yes' : 'No'))
      when 'creative_member'
        tokens.store('Order Type', 'Creative Team Member')
        tokens.store('Agreed to Billing Terms', ((pc.billing_acceptance == true) ? 'Yes' : 'No'))
      when 'marketing'
        tokens.store('Order Type', 'Marketing Purposes')
        tokens.store('Has author bio', ((pc.has_author_profile == true) ? 'Yes' : 'No'))
        tokens.store('Has Marketing Plan', ((pc.has_marketing_plan == true) ? 'Yes' : 'No'))
        tokens.store('Marketing Plan', pc.marketing_plan_link)

        if(pc.marketing_copy_message != '')
          tokens.store('Marketing Message', ('<pre>' + pc.marketing_copy_message + '</pre>').html_safe)
        end
    end

    tokens.store('Quantity', pc.quantity)
    tokens.store('Ship To name', pc.shipping_recipient)
    tokens.store('Phone Contact', pc.contact_phone)

    tokens.store('Address 1', pc.shipping_address_street_1)
    tokens.store('Address 2', pc.shipping_address_street_2)
    tokens.store('City', pc.shipping_address_city)
    tokens.store('State/Province/Region', pc.shipping_address_state)
    tokens.store('Zip', pc.shipping_address_zip)
    tokens.store('Country', pc.shipping_address_country)

    if(pc.expedite_instructions != '')
      tokens.store('Expedite Instructions', ('<pre>' + pc.expedite_instructions + '</pre>').html_safe)
    end

    user_subject = "Print Corner from #{current_user.name} for #{project.title}"
    admin_subject = "New " + user_subject

    send_email_message('print_corner', tokens, get_project_recipient_list(@project), user_subject)
    send_email_message('print_corner_admin', tokens, admin_print_corner_list, admin_subject)
  end

  private

  # Generic email send pattern that just passes a simple hash table
  def send_email_message (template_name, message_tokens, recipient_list, subject)
    recipient_list = Array(recipient_list) unless recipient_list.is_a?(Array)

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
  def get_project_recipient_list(project, excluded_emails = Array::[])
    list = []

    # If current_user is set, attempt to add them to the recipient list
    if ! @current_user.nil?
      list << "#{@current_user.name} <#{@current_user.email}>"
    end

    project.team_memberships.each do  |m|
      if excluded_emails.include?(m.member.email)
        next
      end
      list << "#{m.member.name} <#{m.member.email}>"
    end
    list.uniq
  end

  # Used for Project Created updates to Admin
  def admin_project_created_list
    %w( jesse@booktrope.com andy@booktrope.com )
  end

  # Notify for a member removal request
  def admin_remove_member_request_list
    %w( jesse@booktrope.com andy@booktrope.com )
  end

  # Used when a new team member is added
  def admin_accept_team_member_list
    %w( jesse@booktrope.com )
  end

  # The original manuscript has been uploaded
  def admin_original_manuscript_list
    %w( jesse@booktrope.com )
  end

  # Used for Status Updates to Admin
  def admin_status_update_list
    %w( andy@booktrope.com )
  end

  # Used for Control Number updates
  def admin_edit_control_numbers_list
    %w( andy@booktrope.com justin.jeffress@booktrope.com kate.burkett@booktrope.com )
  end

  # Notify Payroll list of a new 1099 in Box
  def admin_1099_received_list
    %w( Payroll@booktrope.com )
  end

  # Notify of an allocation change
  def admin_rev_allocation_change_list
    %w( evie.hutton@booktrope.com )
  end

  # Notifications for when a user uploads an edited manuscript
  def admin_edited_manuscript_list
    %w( jesse@booktrope.com adam.bodendieck@booktrope.com jennifer.gilbert@booktrope.com )
  end

  # The marketing release date has been set
  def admin_marketing_release_date_list
    %w( adam.bodendieck@booktrope.com )
  end

  # A new stock cover image has been uploaded
  def admin_add_stock_cover_image_list
    %w( adam.bodendieck@booktrope.com )
  end

  # The layout has been uploaded
  def admin_layout_upload_list
    %w( andy@booktrope.com adam.bodendieck@booktrope.com )
  end

  # The final page count has been updated
  def admin_final_page_count_list
    %w( andy@booktrope.com adam.bodendieck@booktrope.com )
  end

  # Images have been requested
  def admin_request_images_list
    %w( andy@booktrope.com adam.bodendieck@booktrope.com )
  end

  # The proofed manuscript has been uploaded
  def admin_proofed_manuscript_list
    %w( victoria@booktrope.com adam.bodendieck@booktrope.com kate.burkett@booktrope.com )
  end

  # The layout style has been selected
  def admin_edit_layout_style_list
    %w( victoria@booktrope.com adam.bodendieck@booktrope.com kate.burkett@booktrope.com )
  end

  # The layout has been approved
  def admin_layout_approved_list
    %w( victoria@booktrope.com adam.bodendieck@booktrope.com kate.burkett@booktrope.com )
  end

  # The Cover Concept has been uploaded
  def admin_cover_concept_upload_list
    %w( ksears@booktrope.com andy@booktrope.com jennifer.gilbert@booktrope.com )
  end

  # The cover art has been approved
  def admin_approve_cover_art_list
    %w( victoria@booktrope.com adam.bodendieck@booktrope.com katherine@booktrope.com jennifer.gilbert@booktrope.com )
  end

  def admin_upload_cover_templates_list
    %w( adam.bodendieck@booktrope.com victoria@booktrope.com kate.burkett@booktrope.com )
  end

  def admin_artwork_rights_request_list
    %w( Evie.Hutton@booktrope.com jesse@booktrope.com andy@booktrope.com )
  end

  def admin_blurb_submit_list
    %w( andy@booktrope.com jennifer.gilbert@booktrope.com ksears@booktrope.com )
  end

  def admin_blurb_approve_list
    %w( andy@booktrope.com jennifer.gilbert@booktrope.com ksears@booktrope.com )
  end

  def admin_publication_fact_sheet_list
    %w( adam.bodendieck@booktrope.com victoria@booktrope.com kate.burkett@booktrope.com )
  end

  def admin_final_manuscript_list
    %w( andy@booktrope.com jesse@booktrope.com adam.bodendieck@booktrope.com victoria@booktrope.com )
  end

  def admin_publish_book_list
    %w( andy@booktrope.com jesse@booktrope.com adam.bodendieck@booktrope.com )
  end

  def admin_media_kit_list
    %w( andy@booktrope.com )
  end

  def admin_blog_tour_list
    %w( ksears@booktrope.com payroll@booktrope.com )
  end

  def admin_price_promo_list
    %w( Pennie.dade@booktrope.com kate.burkett@booktrope.com andy@booktrope.com adam.bodendieck@booktrope.com justin.jeffress@booktrope.com )
  end

  def admin_print_corner_list
    %w( adam.bodendieck@booktrope.com )
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