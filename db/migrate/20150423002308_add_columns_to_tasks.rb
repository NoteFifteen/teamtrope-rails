class AddColumnsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :team_only, :boolean, default: true
  end
end
