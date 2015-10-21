class ShuffleManuscriptColumns < ActiveRecord::Migration
  def change
    rename_column :manuscripts, :proofed_file_name,         :proofread_complete_file_name
    rename_column :manuscripts, :proofed_file_size,         :proofread_complete_file_size
    rename_column :manuscripts, :proofed_content_type,      :proofread_complete_content_type
    rename_column :manuscripts, :proofed_updated_at,        :proofread_complete_updated_at
    rename_column :manuscripts, :proofed_direct_upload_url, :proofread_complete_direct_upload_url
    rename_column :manuscripts, :proofed_file_processed,    :proofread_complete_file_processed

    add_column :manuscripts, :proofed_file_name,         :string
    add_column :manuscripts, :proofed_file_size,         :integer
    add_column :manuscripts, :proofed_content_type,      :string
    add_column :manuscripts, :proofed_updated_at,        :datetime
    add_column :manuscripts, :proofed_direct_upload_url, :string
    add_column :manuscripts, :proofed_file_processed,    :boolean

    add_column :manuscripts, :first_pass_edit_file_name,         :string
    add_column :manuscripts, :first_pass_edit_file_size,         :integer
    add_column :manuscripts, :first_pass_edit_content_type,      :string
    add_column :manuscripts, :first_pass_edit_updated_at,        :datetime
    add_column :manuscripts, :first_pass_edit_direct_upload_url, :string
    add_column :manuscripts, :first_pass_edit_file_processed,    :boolean
  end
end
