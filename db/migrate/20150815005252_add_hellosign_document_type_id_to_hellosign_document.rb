class AddHellosignDocumentTypeIdToHellosignDocument < ActiveRecord::Migration
  def change

    #add_reference :hellosign_documents, :hellosignable, polymorphic: true, after: :status, before: :created_at, index: { name: "index_hellosign_documents_hellosignable_type_and_id" }

    add_reference :hellosign_documents, :hellosign_document_type, after: :status, before: :created_at, index: true
    #add_column  :hellosign_documents, :hellosignable_id, :integer,  after: :status, before: :created_at
    #add_column  :hellosign_documents, :hellosignable_type, :string, after: :hellosignable_id, before: :created_at
  end
end
