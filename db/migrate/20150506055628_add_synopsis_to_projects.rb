class AddSynopsisToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :synopsis, :text
  end
end
