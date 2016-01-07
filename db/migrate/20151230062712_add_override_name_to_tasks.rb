class AddOverrideNameToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :override_name, :string
  end
end
