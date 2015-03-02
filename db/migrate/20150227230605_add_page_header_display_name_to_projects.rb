class AddPageHeaderDisplayNameToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :page_header_display_name, :string
  end
end
