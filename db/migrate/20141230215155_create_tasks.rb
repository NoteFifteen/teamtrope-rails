class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :workflow, index: true
      t.integer :next_id
      t.integer :rejected_task_id
      t.string :partial
      t.string :name
      t.string :icon
      t.string :tab_text
      t.string :intro_video
      t.integer :days_to_complete

      t.timestamps
    end
    add_index :tasks, :next_id
    add_index :tasks, :rejected_task_id
  end
end