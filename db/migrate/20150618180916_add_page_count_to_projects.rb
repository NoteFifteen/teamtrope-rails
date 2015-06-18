class AddPageCountToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :page_count, :integer, after: :final_title
  end
end
