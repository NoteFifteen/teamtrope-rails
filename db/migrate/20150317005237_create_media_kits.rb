class CreateMediaKits < ActiveRecord::Migration
  def change
    create_table :media_kits do |t|
      t.references :project, index: true
      t.attachment :document

      t.timestamps
    end
  end
end
