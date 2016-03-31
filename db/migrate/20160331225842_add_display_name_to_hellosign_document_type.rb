class AddDisplayNameToHellosignDocumentType < ActiveRecord::Migration
  def change
    add_column :hellosign_document_types, :display_name, :string
  end
end
