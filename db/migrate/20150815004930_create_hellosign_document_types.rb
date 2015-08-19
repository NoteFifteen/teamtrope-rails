class CreateHellosignDocumentTypes < ActiveRecord::Migration
  def change
    create_table :hellosign_document_types do |t|
      t.string :name
      t.string :subject
      t.text :message
      t.string :template_id
      t.json :signers
      t.json :ccs

      t.timestamps
    end
  end
end
