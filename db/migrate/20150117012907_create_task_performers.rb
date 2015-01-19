class CreateTaskPerformers < ActiveRecord::Migration
  def change
    create_table :task_performers do |t|
      t.references :task, index: true
      t.references :role, index: true

      t.timestamps
    end
  end
end
