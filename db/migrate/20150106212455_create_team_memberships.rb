class CreateTeamMemberships < ActiveRecord::Migration
  def change
    create_table :team_memberships do |t|
      t.references :project, index: true
      t.integer :member_id
      t.references :role, index: true
      t.float :percentage

      t.timestamps
    end
    add_index :team_memberships, :member_id
    add_index :team_memberships, [:project_id, :member_id, :role_id]
  end
end
