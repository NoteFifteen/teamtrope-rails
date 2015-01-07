class CreateRequiredRoles < ActiveRecord::Migration
  def change
    create_table :required_roles do |t|
      t.references :role, index: true
      t.references :project_type, index: true
      t.float :suggested_percent

      t.timestamps
    end
  end
end
