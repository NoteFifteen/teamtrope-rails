class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
	    t.references :project_view, index: true
      t.string :name
      t.string :color
      t.string :color_value
      t.string :icon
      t.integer :order, index: true

      t.timestamps
    end
  end
end
