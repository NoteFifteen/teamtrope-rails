class CreateChannelReports < ActiveRecord::Migration
  def change
    create_table :channel_reports do |t|
      t.datetime :scan_date

      t.timestamps
    end
  end
end
