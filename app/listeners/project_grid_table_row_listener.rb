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

  def update_task(project, task)
    pgtr = project.project_grid_table_row
    pgtr[task.workflow.name.downcase.gsub(/ /, "_") + "_task_id"] = task.id
    pgtr[task.workflow.name.downcase.gsub(/ /, "_") + "_task_name"] = task.name
    pgtr[task.workflow.name.downcase.gsub(/ /, "_") + "_task_last_update"] = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    pgtr.save
  end

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

    # adding the current_tasks
    project.current_tasks.includes(:task => :workflow).each do | ct |
      pgtr[ct.task.workflow.name.downcase.gsub(/ /, "_") + "_task_id"] = ct.task.id
      pgtr[ct.task.workflow.name.downcase.gsub(/ /, "_") + "_task_name"] = ct.task.name
      pgtr[ct.task.workflow.name.downcase.gsub(/ /, "_") + "_task_last_update"] = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end

    pgtr.save
  end

end

