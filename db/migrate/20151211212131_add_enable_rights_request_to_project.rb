class AddEnableRightsRequestToProject < ActiveRecord::Migration
  def change
    add_column :projects, :enable_rights_request, :boolean, default: :false
  end
end
