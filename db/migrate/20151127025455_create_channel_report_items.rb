class CreateChannelReportItems < ActiveRecord::Migration
  def change
    create_table :channel_report_items do |t|
      t.references :channel_report, index: true
      t.string :title
      t.string :parse_id
      t.boolean :kdp_select, default: false
      t.boolean :amazon, default: false
      t.boolean :apple, default: false
      t.boolean :nook, default: false
      t.string :amazon_link
      t.string :apple_link
      t.string :nook_link

      t.timestamps
    end
  end
end
