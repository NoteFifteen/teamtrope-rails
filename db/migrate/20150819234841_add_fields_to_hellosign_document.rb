class AddFieldsToHellosignDocument < ActiveRecord::Migration
  def change
    add_column :hellosign_documents, :signing_url, :string
    add_column :hellosign_documents, :final_copy_uri, :string
    add_column :hellosign_documents, :details_url, :string
    add_column :hellosign_documents, :is_complete, :bool, default: false
    add_column :hellosign_documents, :has_error, :bool, default: false
  end
end
