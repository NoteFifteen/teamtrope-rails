class CreateWorkflows < ActiveRecord::Migration
  def change
    create_table :workflows do |t|
      t.string :name
      t.integer :root_step_id
      
      t.timestamps
    end
    add_index :workflows, :root_step_id
  end
end
