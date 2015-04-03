class CreateHellosignDocuments < ActiveRecord::Migration
  def change
    create_table :hellosign_documents do |t|
      t.string :name
      t.string :hellosign_id
      t.string :status

      t.timestamps
    end
  end
end
