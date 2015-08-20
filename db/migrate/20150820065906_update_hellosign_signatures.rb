class UpdateHellosignSignatures < ActiveRecord::Migration
  def change
    remove_column :hellosign_signatures, :team_membership_id, :integer

    add_column :hellosign_signatures, :signature_id, :string, before: :created_at
    add_column :hellosign_signatures, :signer_email_address, :string, before: :created_at
    add_column :hellosign_signatures, :signer_name, :string, before: :created_at
    add_column :hellosign_signatures, :order, :integer, before: :created_at
    add_column :hellosign_signatures, :status_code, :string, before: :created_at
    add_column :hellosign_signatures, :error, :string, before: :created_at

    add_column :hellosign_signatures, :signed_at, :datetime, before: :created_at
    add_column :hellosign_signatures, :last_viewed_at, :datetime, before: :created_at
    add_column :hellosign_signatures, :last_reminded_at, :datetime, before: :created_at
  end
end
