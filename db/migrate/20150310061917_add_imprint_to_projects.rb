class AddImprintToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :imprint, index: true
  end
end
