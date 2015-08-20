class RemoveTeamMembershipIdFromHellosignSignature < ActiveRecord::Migration
  def change
    remove_column :hellosign_signatures, :team_membership_id, :integer
  end
end
