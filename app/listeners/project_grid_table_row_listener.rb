# app/listeners/team_memberships_listener.rb
class ProjectGridTableRowListener

  # updates the ProjectGridTableRow entry's role column after adding or removing a member of role_id
  def modify_team_member(project, role_id)

    role_name = Role.find(role_id).name.downcase.gsub(/ /, "_")

    # These are not roles in the PGTR
    return if %w( advisor agent ).include?(role_name)

    # getting the project_grid_table_row
    pgtr = project.project_grid_table_row

    # setting the role column to a comma delimited list for member names for that role
    pgtr[role_name] = project.team_memberships
    .where(role: role_id)
    .map(&:member)
    .map(&:name).join(", ")


    pgtr[role_name + "s_pct"] = project.team_memberships
      .includes(:member)
      .where(role: role_id)
      .map{ |member| "#{member.member.name} (#{member.percentage})" }
      .join(", ")

    pgtr.total_pct = project.team_memberships.map(&:percentage).inject(:+)
    
    pgtr.save
  end

  def modify_project(project)
    pgtr = project.project_grid_table_row
    pgtr ||= project.build_project_grid_table_row

    pgtr.title = project.book_title
    pgtr.teamroom_link = project.teamroom_link
    pgtr.genre = project.genres.map(&:name).join(", ")
    pgtr.save
  end

  def modify_imprint(project)
    unless project.imprint.nil?
      pgtr = project.project_grid_table_row
      pgtr.imprint = project.imprint.name
      pgtr.save
    end
  end

  # update the control number fields for the pgtr
  def submit_control_numbers(project)
    unless project.control_number.nil?
      pgtr = project.project_grid_table_row
      pgtr.asin            = project.control_number.asin
      pgtr.paperback_isbn  = project.control_number.paperback_isbn
      pgtr.epub_isbn       = project.control_number.epub_isbn
      pgtr.save
    end
  end

  # update the final page count for the pgtr
  def update_final_page_count(project)
    unless project.layout.nil?
      pgtr = project.project_grid_table_row
      pgtr.page_count = project.layout.final_page_count
    end
  end

  def submit_to_layout(project)
    pgtr = project.project_grid_table_row
    pgtr.book_format = project.book_type_pretty

    pgtr.save
  end

  def update_publication_date(project, publication_date)
    pgtr = project.project_grid_table_row
    pgtr.publication_date = publication_date
    pgtr.save
  end

  def prefunk_enrollement(project)
    pgtr = project.project_grid_table_row
    pgtr.prefunk_enrolled = "Yes"
    pgtr.prefunk_enrollment_date = project.prefunk_enrollment.created_at.strftime("%m/%d/%Y")

    pgtr.save
  end

  # update the pgtr once the pfs has been subitted.
  def update_pfs(project)
    pgtr = project.project_grid_table_row
    pfs = project.pfs

    pgtr.series_name   = pfs.series_name
    pgtr.series_number = pfs.series_number
    pgtr.pfs_author_name = pfs.author_name

    pgtr.formatted_print_price = "$#{"%.2f" % pfs.print_price}" unless pfs.print_price.nil?
    unless pfs.ebook_price.nil?
      pgtr.formatted_ebook_price = "$#{"%.2f" %pfs.ebook_price}"
      library_price = ApplicationHelper.lookup_library_pricing(pfs.ebook_price)
      pgtr.formatted_library_price = library_price unless library_price.nil?
    end

    pgtr.bisac_one_code          = pfs.bisac_code_one
    pgtr.bisac_one_description   = pfs.bisac_code_name_one


    pgtr.bisac_two_code          = pfs.bisac_code_two
    pgtr.bisac_two_description   = pfs.bisac_code_name_two



    pgtr.bisac_three_code        = pfs.bisac_code_three
    pgtr.bisac_three_description = pfs.bisac_code_name_three


    pgtr.search_terms   = pfs.search_terms
    pgtr.description    = ApplicationHelper.filter_special_characters(pfs.description)    unless pfs.description.nil?
    pgtr.author_bio     = ApplicationHelper.filter_special_characters(pfs.author_bio)     unless pfs.author_bio.nil?
    pgtr.one_line_blurb = ApplicationHelper.filter_special_characters(pfs.one_line_blurb) unless pfs.one_line_blurb.nil?

    pgtr.save
  end

  def update_task(project, task)
    pgtr = project.project_grid_table_row
    keybase = task.workflow.name.downcase.gsub(/ /, "_")
    pgtr[keybase + "_task_id"] = task.id
    pgtr[keybase + "_task_name"] = task.name
    pgtr[keybase + "_task_display_name"] = task.display_name
    pgtr[keybase + "_task_last_update"] = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    pgtr.save
  end

  # create_project must ONLY be published via projects#create
  def create_project(project)
    pgtr = project.build_project_grid_table_row
    pgtr.title = project.book_title
    pgtr.genre = project.genres.map(&:name).join(", ")
    pgtr.teamroom_link = project.teamroom_link

    roles = Hash[*Role.all.map{ | role | [role.name.downcase.gsub(/ /, "_").to_sym, role.id] }.flatten]

    # These are not roles in the PGTR
    roles.delete_if {|name, id| name == :advisor || name == :agent }

    # adding each role
    roles.each do | key, value |
      pgtr[key] = project.team_memberships.includes(:member).where(role_id: value).map(&:member).map(&:name).join(", ")
    end

    # since the publisher only publishes :create_project on projects#create
    # there will only every be one author since we only allow one author selection
    # when creating a new project. We can also skip other_contributors
    author = project.team_memberships
      .includes(:member)
      .where(role: Role.find_by_name("Author")).first.member

    pgtr.author_last_first = author.last_name_first
    pgtr.author_first_last = author.name

    # adding the current_tasks
    project.current_tasks.includes(:task => :workflow).each do | ct |
      keybase = ct.task.workflow.name.downcase.gsub(/ /, "_")
      pgtr[keybase + "_task_id"] = ct.task.id
      pgtr[keybase + "_task_name"] = ct.task.name
      pgtr[keybase + "_task_display_name"] = ct.task.display_name
      pgtr[keybase + "_task_last_update"] = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end

    pgtr.save
  end

end
