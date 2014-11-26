class AddPcrFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :step_mkt_info, :string
    add_column :projects, :step_cover_design, :string
    add_column :projects, :pcr_step, :string
  end
end
