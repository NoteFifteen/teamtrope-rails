class CreateTaskPrerequisiteFields < ActiveRecord::Migration
  def change
    create_table :task_prerequisite_fields do |t|
      t.references :task, index: true
      t.string :field_name

      t.timestamps
    end
  end
end
