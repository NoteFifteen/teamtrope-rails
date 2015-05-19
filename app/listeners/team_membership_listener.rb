# app/listeners/team_memberships_listener.rb
class TeamMembershipListener

  # updates the ProjectGridTableRow entry's role column after adding or removing a member of role_id
  def modify_team_member(project, role_id)

    # getting the project_grid_table_row
    pgtr = project.project_grid_table_row

    # setting the role column to a comma dilimited list fo member names for that role
    pgtr[Role.find(role_id).name.downcase.gsub(/ /, "_")] = project.team_memberships
    .where(role: role_id)
    .map(&:member)
    .map(&:name).join(", ")

    pgtr.save
  end

end
