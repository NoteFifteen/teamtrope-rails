class AddAgentAndAdvisorToRequiredRoles < ActiveRecord::Migration
  RoleAdditions = [
      { name: 'Agent', contract_description: 'The Agent role contract text'},
      { name: 'Advisor', contract_description: 'The Advisor role contract text'}
  ]

  # Add the role and the required_role to the Standard Project project type.
  def up
    project_type = get_project_type

    RoleAdditions.each do |role_hash|
      role = Role.create!(role_hash)

      RequiredRole.create!({
          :role_id => role.id,
          :project_type_id => project_type.id,
          :suggested_percent => 0.0
      })
    end
  end

  # Remove the role, the required_role, and any team_memberships using the role.
  def down
    project_type = get_project_type

    RoleAdditions.each do |role_hash|
      role = Role.where(:name => role_hash[:name]).first

      RequiredRole.where(:role_id => role.id, :project_type_id => project_type.id).destroy_all
      TeamMembership.where(:role_id => role.id).destroy_all

      # Destroy should delete any dependants
      role.destroy

    end
  end

  def get_project_type
    ProjectType.where(name: "Standard Project", team_total_percent: 70.0).first_or_create
  end

end
