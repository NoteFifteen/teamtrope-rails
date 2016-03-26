# app/listeners/team_memberships_listener.rb
class TeamMembershipListener

  # updates the ProjectGridTableRow entry's role column after adding or removing a member of role_id
  def modify_team_member(project, role_id)

    # getting the project_grid_table_row
    pgtr = project.project_grid_table_row

    # setting the role column to a comma dilimited list fo member names for that role
    role = Role.find(role_id)
    role_name = role.name.downcase.gsub(/ /, "_")

    return if %w( advisor agent ).include?(role_name)

    pgtr[role_name] = project.team_memberships
      .includes(:member)
      .where(role: role_id)
      .map(&:member)
      .map(&:name).join(", ")

    pgtr.team_and_pct = team_and_pct project


    pgtr[key + "s_pct"] = project.team_memberships
      .includes(:member)
      .where(role: role_id)
      .map{ |member| "#{member.member.name} (#{member.percentage})" }
      .join(", ")

    pgtr.total_pct = project.team_memberships.map(&:percentage).inject(:+)


    # only update the author fields if we've added the author.
    if role.name.downcase.gsub(/ /, "_") == "author"
      # author_columns returns three results:
      # ( author_last_first, author_first_last, and other_contributors )
      # if there are are two authors most likely the main author was the one added first
      pgtr.author_last_first, pgtr.author_first_last, pgtr.other_contributors = author_columns project.authors.order(created_at: :asc)
    end
    pgtr.save
  end

  private
  def team_and_pct(project)
    %Q{#{project.team_members_with_roles_and_pcts.map{ |n|
          "#{n[:member].name} #{
            n[:role_pcts].map{ |role_pcts |
              "(#{role_pcts[:role]} #{role_pcts[:pct]})"}.join(',')
          }" }.join(';')
        }; Total (#{project.total_team_percent_allocation})}
  end

  def author_columns(authors)
    author_last_first = nil
    author_first_last = nil
    other_contributors = nil

    unless authors.count < 1
      first_author = authors.first
      author_last_first = first_author.member.last_name_first
      author_first_last = first_author.member.name

      other_contributors = authors.reject{ | a |
        a.id == first_author.id
      }.map { | author |
        "#{author.member.name} (#{author.role.name})"
      }.join(', ')
    end
    [author_last_first, author_first_last, other_contributors]
  end
end
