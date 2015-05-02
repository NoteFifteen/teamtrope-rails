class CreateArtworkRightsRequests < ActiveRecord::Migration
  def change
    create_table :artwork_rights_requests do |t|
      t.references :project, index: true
      t.string :role_type
      t.string :full_name
      t.string :email

      t.timestamps
    end
  end
end
