class CreateTaskPrerequisiteFields < ActiveRecord::Migration
  def change
    create_table :task_prerequisite_fields do |t|
      t.references :workflow_step, index: true
      t.string :field_name

      t.timestamps
    end
    add_index :task_prerequisite_fields, :field_name
  end
end
