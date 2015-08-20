class AddFieldsToHellosignSignature < ActiveRecord::Migration
  def change
    add_column :hellosign_signatures, :signature_id, :string
    add_column :hellosign_signatures, :signer_email_address, :string
    add_column :hellosign_signatures, :signer_name, :string
    add_column :hellosign_signatures, :order, :integer
    add_column :hellosign_signatures, :status_code, :string
    add_column :hellosign_signatures, :signed_at, :datetime
    add_column :hellosign_signatures, :last_viewed_at, :datetime
    add_column :hellosign_signatures, :last_reminded_at, :datetime
    add_column :hellosign_signatures, :error, :string
  end
end
