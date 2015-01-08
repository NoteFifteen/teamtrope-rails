class CreateWorkflows < ActiveRecord::Migration
  def change
    create_table :workflows do |t|
      t.string :name
      t.integer :root_task_id
      
      t.timestamps
    end
    add_index :workflows, :root_task_id
  end
end
