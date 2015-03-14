class CreateStatusUpdates < ActiveRecord::Migration
  def change
    create_table :status_updates do |t|
      t.references :project, index: true
      t.integer :type_index
      t.string :status

      t.timestamps
    end
  end
end
