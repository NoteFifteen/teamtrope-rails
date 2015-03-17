class CreateAuditTeamMembershipRemovals < ActiveRecord::Migration
  def change
    create_table :audit_team_membership_removals do |t|
      t.references :project, index: true
      t.integer :member_id, index: true
      t.references :role
      t.float :percentage
      t.string :reason
      t.text :notes
      t.boolean :notified_member

      t.timestamps
    end
  end
end
