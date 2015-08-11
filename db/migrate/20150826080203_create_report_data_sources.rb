class CreateReportDataSources < ActiveRecord::Migration
  def change
    create_table :report_data_sources do |t|
      t.string :name
      t.string :name_short

      t.timestamps
    end
  end
end
