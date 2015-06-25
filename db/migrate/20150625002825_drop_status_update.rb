class DropStatusUpdate < ActiveRecord::Migration

  def up
    drop_table :status_updates
  end

  def down
    create_table "status_updates", force: true do |t|
      t.integer  "project_id"
      t.integer  "type_index"
      t.string   "status"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

end
