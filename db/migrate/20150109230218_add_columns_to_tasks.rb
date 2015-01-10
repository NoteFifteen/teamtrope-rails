class AddColumnsToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :phase, index: true
    add_column :tasks, :horizontal_order, :integer
    add_index :tasks, :horizontal_order
  end
end
