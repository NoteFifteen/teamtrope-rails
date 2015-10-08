class RemoveNameFromHellosignDocuments < ActiveRecord::Migration
  def self.up
    remove_column :hellosign_documents, :name
  end

  def self.down
    add_column :hellosign_documents, :name, :string
  end
end
