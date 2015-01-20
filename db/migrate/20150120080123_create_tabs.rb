class CreateTabs < ActiveRecord::Migration
  def change
    create_table :tabs do |t|
      t.references :task, index: true
      t.references :phase, index: true
      t.integer :order

      t.timestamps
    end
  end
end
