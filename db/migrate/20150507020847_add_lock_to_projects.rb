class AddLockToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :lock, :boolean, default: false
    add_column :projects, :done, :boolean, default: false
  end
end
