class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :type
      t.string :name
      t.string :icon
      t.string :tab_text
      t.string :intro_video
      t.integer :days_to_complete

      t.timestamps
    end
  end
end
