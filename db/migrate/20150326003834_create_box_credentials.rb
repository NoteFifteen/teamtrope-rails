class CreateBoxCredentials < ActiveRecord::Migration
  def change
    create_table :box_credentials do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :anti_forgery_token

      t.timestamps
    end
    add_index :box_credentials, :anti_forgery_token, unique: true
  end
end
