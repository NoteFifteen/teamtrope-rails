class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
     t.references :user, index: true
     t.attachment :avatar
    end
  end
end
