class UpdateHellosignDocuments < ActiveRecord::Migration
  def change
    add_reference :hellosign_documents, :hellosign_document_type, after: :status, before: :created_at, index: true
    add_reference :hellosign_documents, :team_membership, index: true, before: :created_at


    add_column :hellosign_documents, :signing_url, :string, before: :created_at
    add_column :hellosign_documents, :files_url, :string, before: :created_at
    add_column :hellosign_documents, :details_url, :string, before: :created_at
    add_column :hellosign_documents, :is_complete, :bool, default: false, before: :created_at
    add_column :hellosign_documents, :pending_cancellation, :bool, default: false, before: :created_at
    add_column :hellosign_documents, :cancelled, :bool, default: false, before: :created_at
    add_column :hellosign_documents, :has_error, :bool, default: false, before: :created_at
  end
end
