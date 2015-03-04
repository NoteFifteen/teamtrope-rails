class AddApprovalDataToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :layout_approval_issue_list, :text, after: :layout_approved_date
    add_column :projects, :layout_approved, :string, after: :layout_approved_date
  end
end
