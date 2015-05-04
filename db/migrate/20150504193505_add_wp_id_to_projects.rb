class AddWpIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :wp_id, :integer
    add_index :projects, :wp_id
  end
end
