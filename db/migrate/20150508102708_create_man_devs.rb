class CreateManDevs < ActiveRecord::Migration
  def change
    create_table :man_devs do |t|
      t.references :project, index: true
      t.string :man_dev_decision
      t.datetime :man_dev_end_date

      t.timestamps
    end
  end
end
