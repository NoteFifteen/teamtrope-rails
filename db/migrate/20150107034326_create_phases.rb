class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.string :name
      t.string :color
      t.string :color_value
      t.string :icon
      t.integer :verticial_order

      t.timestamps
    end
  end
end
