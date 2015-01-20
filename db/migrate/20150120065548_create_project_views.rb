class CreateProjectViews < ActiveRecord::Migration
  def change
    create_table :project_views do |t|
      t.references :project_type, index: true

      t.timestamps
    end
  end
end
