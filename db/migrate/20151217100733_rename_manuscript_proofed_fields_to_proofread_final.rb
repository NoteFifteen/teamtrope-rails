class RenameManuscriptProofedFieldsToProofreadFinal < ActiveRecord::Migration
  def change

    rename_column :manuscripts, :proofed_content_type,           :proofread_final_content_type
    rename_column :manuscripts, :proofed_file_direct_upload_url, :proofread_final_file_direct_upload_url
    rename_column :manuscripts, :proofed_file_name,              :proofread_final_file_name
    rename_column :manuscripts, :proofed_file_processed,         :proofread_final_file_processed
    rename_column :manuscripts, :proofed_file_size,              :proofread_final_file_size
    rename_column :manuscripts, :proofed_updated_at,             :proofread_final_updated_at

  end

end
