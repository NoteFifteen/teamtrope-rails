class AddDirectUploadFieldsToFinalManuscript < ActiveRecord::Migration
  def change
    add_column :final_manuscripts, :doc_direct_upload_url, :string, default: nil
    add_column :final_manuscripts, :doc_processed, :boolean, default: false

    add_column :final_manuscripts, :pdf_direct_upload_url, :string, default: nil
    add_column :final_manuscripts, :pdf_processed, :boolean, default: false
  end
end
