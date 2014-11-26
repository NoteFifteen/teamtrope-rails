class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :form_name
      t.datetime :date
      t.float :project_id
      t.float :user_id
      t.float :entry_id
      t.string :process_step

      t.timestamps
    end
  end
end
