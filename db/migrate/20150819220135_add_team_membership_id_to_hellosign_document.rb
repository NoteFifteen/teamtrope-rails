class AddTeamMembershipIdToHellosignDocument < ActiveRecord::Migration
  def change
    add_reference :hellosign_documents, :team_membership, index: true
  end
end
