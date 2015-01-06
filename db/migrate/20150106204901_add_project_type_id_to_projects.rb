class AddProjectTypeIdToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :project_type, index: true
  end
end
