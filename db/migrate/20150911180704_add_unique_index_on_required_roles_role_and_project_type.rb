class AddUniqueIndexOnRequiredRolesRoleAndProjectType < ActiveRecord::Migration
  def change
    add_index :required_roles, [:role_id, :project_type_id], unique: true
  end
end
