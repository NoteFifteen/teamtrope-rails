class AddColumnToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :development, :boolean
  end
end
