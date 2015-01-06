class CreateProjectTypes < ActiveRecord::Migration
  def change
    create_table :project_types do |t|
      t.string :name
      t.float :team_total_percent

      t.timestamps
    end
  end
end
