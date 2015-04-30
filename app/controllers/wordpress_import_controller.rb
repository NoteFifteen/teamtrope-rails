class WordpressImportController < ApplicationController
  before_action :signed_in_user
  before_action :booktrope_staff
  def import
  end

  def upload
    # turning off callbacks so we don't send CTAs when we create TeamMemberships
    ActiveRecord::Base.skip_callbacks = true
    @import_meta = {}
    @errors = []
    case params[:type]
    when 'projects'
      import_projects
    when 'users'
      import_users
    else
    end
    ActiveRecord::Base.skip_callbacks = false
  end

  private

  def import_users
    require 'csv'
    csv = CSV.parse(params[:upload_file].read, headers: :first_row)
    total = 0
    csv.each do | import_user |
      #puts "#{import_user['ID']},#{import_user['user_login']},#{import_user['user_email']},#{import_user["roles"]},#{import_user["Role(s)"]}\n"
      #User.create!(uid: import_user['ID'], name: import_user['user_login'], email: import_user['user_email'])

      user = User.where(uid: import_user['ID'],
        name: import_user['display_name'],
        email: import_user['user_email'],
        provider: 'wordpress_hosted').first_or_create

      user.roles = import_user["Role(s)"].downcase.gsub(/ /, '_').split('::')

      if import_user['roles'] == 'inactive' || import_user['roles'] == 'unapproved'
        @errors.push({type: (import_user['roles'] == 'inactive')? "User::Inactive" : "User:Unapproved" ,
          message: "User: #{user.name} with id: #{user.uid} was set to inactive"})
        user.active = false
      end
      user.build_profile if user.profile.nil?
      user.save
      total = total + 1
    end
    @import_meta[:import_total] = total
  end

  def import_projects
    require 'nokogiri'
    # parsing the uploaded xml file
    doc = Nokogiri::XML(params[:upload_file])

    # getting the list of items
    items = doc.xpath("//item")

    # looping through the projects
    total = 0
    items.each_with_index do | item, index |
      next if item.xpath('./wp:status').text == 'trash'
      #puts "#{index}\t#{item.xpath("./wp:post_id").text}\t#{item.xpath("./title").text}"

      # create the project
      project = Project.new(title: item.xpath("./title").text, project_type_id: 1,  **prepare_project_fields(item))
      # build ControlNumber
      project.build_control_number(**prepare_control_number_fields(item))
      # build PublicationFactSheet
      project.build_publication_fact_sheet(**prepare_publication_fact_sheet_fields(item))
      # build CoverConcept
      project.build_cover_concept(**prepare_cover_concept_fields(item))

      genres = fetch_field_value item, 'book_genre'

      unless genres.class != Array
        genres.each do | genre |
            project.book_genres.build(genre: Genre.where(wp_id: genre).first)
        end
      else
        @errors << { type: 'Genre::Missing', message: "Genre missing for #{project.title}" }
      end


      [ { 'Production' => 'book_pcr_step' },
        { 'Design' => 'book_pcr_step_cover_design' },
        { 'Marketing' => 'book_pcr_step_mkt_info' } ].each do | workflow |
          workflow.each do | key, value |
              #puts "#{key}: #{fetch_field_value(item, value)}"
              create_current_task project, item, value
          end
      end

      create_team_memberships project, item

      project.save
      total = total + 1
      #break
    end
    @import_meta[:import_total] = total
  end

  $wf_task_map = {
    #production tasks
    'New Manuscript' => 'Original Manuscript',
    'Edit Complete Date' => 'Edit Cmoplete Date',
    'Submit Edited' => 'Edited Manuscript',
    'Submit Proofread' => 'Submit Proofread',
    'Choose Style' => 'Choose Style',
    'Upload Layout' => 'Upload Layout',
    'Approve Layout' => 'Approve Layout',
    'Final Page Count' => 'Page Count',
    'Final Manuscript' => 'Final Manuscript',
    'Publish Book' => 'Publish Book',
    'Published' => 'Production Complete',

    #Design Tasks
    'Upload Cover Concept' => 'Cover Concept',
    'Approve Cover' => 'Approve Cover Art',
    'Upload Final Covers' => 'Final Covers',
    'Cover Complete' => 'Design Complete',

    #Marketing Tasks
    'Submit PFS' => 'Submit PFS',
    'PFS Complete' => 'Marketing Complete',
  }

  # pct_label is an override most role percents are key + '_pct' the pct_label
  # is for overriding the few cases where it's not
  $wp_rails_role_map = {
    'book_author' => { percent: 33.0, role_name: 'Author'},
    'book_marketing_manager' => { percent: 20.0, role_name: 'Book Manager', pct_label: 'book_manager_pct'},
    'book_cover_designer' => { percent: 4.0, role_name: 'Cover Designer', pct_label: 'book_designer_pct'},
    'book_editor' => { percent: 7.0, role_name: 'Editor'},
    'book_project_manager' => { percent: 4.0, role_name: 'Project Manager'},
    'book_proofreader' => { percent: 2.0, role_name: 'Proof Reader'},
  }

  def create_current_task(project, project_meta, key)
    wp_task_name = fetch_field_value(project_meta, key)
    unless $wf_task_map.has_key? wp_task_name
      if wp_task_name == 'Manuscript Development'
        project.development = true
        task = Task.where(name: 'Original Manuscript').first
        project.current_tasks.build(task: task) unless task.nil?
      else
        @errors.push({type: "CurrentTask::NoMatchingTask", message: "wp task name: #{wp_task_name} project: #{project.title}"})
      end
      return
    end
    task = Task.where(name: $wf_task_map[wp_task_name]).first
    project.current_tasks.build(task: task) unless task.nil?
  end

  def deserialize_php_array(serialized_data)
    results = Array.new
    serialized_data.scan(/i:([0-9])+;s:([0-9]+):\"(.+?)\";/).each do | match |
      results.push match[2]
    end
    results
  end

  def prepare_project_fields(project_meta)
    {
      childrens_book: fetch_field_value(project_meta, 'book_childrens_book'),
      color_interior: fetch_field_value(project_meta, 'book_color_interior'),
      edit_complete_date: fetch_field_value(project_meta, 'book_edit_complete_date'),
      final_title: fetch_field_value(project_meta, 'book_final_title'),
      has_index: fetch_field_value(project_meta, 'book_has_index'),
      has_internal_illustrations: fetch_field_value(project_meta, 'book_has_internal_illustrations'),
      has_sub_chapters: fetch_field_value(project_meta, 'book_has_sub-chapters'),
      marketing_release_date: fetch_field_value(project_meta, 'book_marketing_release_date'),
      non_standard_size: fetch_field_value(project_meta, 'book_non-standard_size'),
      prev_publisher_and_date: fetch_field_value(project_meta, 'book_prev_publisher_published'),
      previously_published: fetch_field_value(project_meta, 'book_previously_published'),
      proofed_word_count: fetch_field_value(project_meta, 'book_proofed_word_count'),
      publication_date: fetch_field_value(project_meta, 'book_publication_date'),
      special_text_treatment: fetch_field_value(project_meta, 'book_special_text_treatment'),
      stock_image_request_link: fetch_field_value(project_meta, 'book_stock_image_request_link'),
      teamroom_link: fetch_field_value(project_meta, 'book_teamroom_link'),
    }
  end

  def prepare_control_number_fields(project_meta)
    {
      apple_id: fetch_field_value(project_meta, 'book_apple_id'),
      asin: fetch_field_value(project_meta, 'book_asin'),
      epub_isbn: fetch_field_value(project_meta, 'book_ebook_isbn'),
      hardback_isbn: fetch_field_value(project_meta, 'book_hardback_isbn'),
      paperback_isbn: fetch_field_value(project_meta, 'book_isbn'),
      parse_id: fetch_field_value(project_meta, 'book_parse_id'),
    }
  end

  def prepare_cover_concept_fields(project_meta)
    {
      cover_art_approval_date: fetch_field_value(project_meta, 'book_cover_art_approval_date'),
      #cover_concept: book_cover_concept,
      cover_concept_notes: fetch_field_value(project_meta, 'book_cover_concept_notes'),
      #stock_cover_image: fetch_field_value(project_meta, 'book_stock_cover_image'),
    }
  end

  def prepare_publication_fact_sheet_fields(project_meta)
    {
      age_range: fetch_field_value(project_meta, 'book_age_range'),
      author_bio: fetch_field_value(project_meta, 'book_author_bio'),
      bisac_code_one: fetch_field_value(project_meta, 'book_bisac_code_1'),
      bisac_code_two: fetch_field_value(project_meta, 'book_bisac_code_2'),
      bisac_code_three: fetch_field_value(project_meta, 'book_bisac_code_3'),
      description: fetch_field_value(project_meta, 'book_blurb_description'),
      ebook_price: fetch_field_value(project_meta, 'book_ebook_price'),
      endorsements: fetch_field_value(project_meta, 'book_endorsements'),
      one_line_blurb: fetch_field_value(project_meta, 'book_blurb_one_line'),
      paperback_cover_type: fetch_field_value(project_meta, 'book_paperback_cover_type'),
      print_price: fetch_field_value(project_meta, 'book_print_price'),
      search_terms: fetch_field_value(project_meta, 'book_search_terms'),
      series_name: fetch_field_value(project_meta, 'book_series_name'),
      series_number: fetch_field_value(project_meta, 'book_series_number')
    }
  end

  def prepare_layout_fields(project_meta)
    {
      exact_name_on_copyright: fetch_field_value(project_meta, 'book_exact_name_on_copyright'),
      final_page_count: fetch_field_value(project_meta, 'book_final_page_count'),
      layout_approved_date: fetch_field_value(project_meta, 'book_layout_approved_date'),
      layout_notes: fetch_field_value(project_meta, 'book_layout_notes'),
      layout_style_choice: fetch_field_value(project_meta, 'book_layout_style_choice'),
      #layout_upload: book_layout_upload
      pen_name: fetch_field_value(project_meta, 'book_pen_name'),
      use_pen_name_for_copyright: fetch_field_value(project_meta, 'book_use_pen_name_for_copyright'),
      use_pen_name_on_title: fetch_field_value(project_meta, 'book_use_pen_name_on_title'),
    }
  end

  def create_team_memberships(project, item)
    #looping through the team member hash
    $wp_rails_role_map.each do | key, tm_hash |
      wp_member_role = fetch_field_value item, key
      # Most corresponding percents for roles from wp are role_name + _pct
      # :pct_label is the override for the outliers
      wp_member_role_pct = fetch_field_value item, (tm_hash.has_key? :pct_label)? tm_hash[:pct_label] : "#{key}_pct"

      ttr_role = Role.where(name: tm_hash[:role_name]).first

      unless ttr_role.nil?
        # wp_member_role can either be an array or a string depending if there are multiple
        # convert single entries to an array so we can loop through.
        wp_member_role = [wp_member_role] unless wp_member_role.class == Array

        wp_member_role.each do | member_id |
          next if member_id.nil? || member_id.to_i < 1
          member = User.where(uid: member_id).first
          unless member.nil?
            project.team_memberships.build(member: member, role: ttr_role, percentage: wp_member_role_pct.nil?? tm_hash[:percent] : wp_member_role_pct.to_f)
          else
            @errors.push({ type: 'TeamMembership::MissingUser', message: "nil user #{member_id} project: #{project.title}role: #{ttr_role.name}"})
          end
        end
        #@errors.push "role info: #{item.xpath("./wp:post_id").text}\t#{wp_member_role}\t#{wp_member_role_pct}\t#{item.xpath("./title").text}"
      else
        @errors.push( { type: 'TeamMembership::UnmappableRole', message: "Unmappable role: #{tm_hash[:role_name]} project: #{project.title}" })
      end
    end
  end

  # fetches the value given the key from a wordpress xml export.
  # fields that are lists are often converted to a serialized php array.
  # Deserialize will deserialze the array into an array of strings.
  def fetch_field_value(item, key, deserialize = true)
    value = item.xpath("./wp:postmeta/wp:meta_key[text() = '#{key}']/following-sibling::wp:meta_value/text()").text
    # check if we need to deserialize array
    if deserialize && value =~ /a:[0-9]+:{i:([0-9]+);s:([0-9]+):\"(.*?)\";}/
      value = deserialize_php_array value
    end
    value
  end

end
