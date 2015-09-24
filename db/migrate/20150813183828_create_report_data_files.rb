class CreateReportDataFiles < ActiveRecord::Migration
  def change
    create_table :report_data_files do |t|
      t.binary :source_file
      t.string :filename
      t.boolean :is_valid, :default => true

      t.timestamps
    end
  end
end
