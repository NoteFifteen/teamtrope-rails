class AddDirectUploadFieldsToManuscripts < ActiveRecord::Migration
  def change
    add_column :manuscripts, :original_file_direct_upload_url, :string, default: nil, after: :original_updated_at
    add_column :manuscripts, :original_file_processed, :boolean, default: false, after: :original_file_direct_upload_url

    add_column :manuscripts, :edited_file_direct_upload_url, :string, default: nil, after: :edited_updated_at
    add_column :manuscripts, :edited_file_processed, :boolean, default: false, after: :edited_file_direct_upload_url

    add_column :manuscripts, :proofed_file_direct_upload_url, :string, default: nil, after: :proofed_updated_at
    add_column :manuscripts, :proofed_file_processed, :boolean, default: false, after: :proofed_file_direct_upload_url
  end
end
