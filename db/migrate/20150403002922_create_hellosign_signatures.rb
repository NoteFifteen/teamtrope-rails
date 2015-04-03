class CreateHellosignSignatures < ActiveRecord::Migration
  def change
    create_table :hellosign_signatures do |t|
      t.references :hellosign_document, index: true
      t.references :team_membership, index: true

      t.timestamps
    end
  end
end
