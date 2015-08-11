class CreateReportDataKdpTypes < ActiveRecord::Migration
  def change
    create_table :report_data_kdp_types do |t|
      t.string :kdp_transaction_type
      t.string :kdp_royalty_type

      t.timestamps
    end

    # We want to force this as unique - Try to normalize the values in the report processor
    # since that's where we want to get or create the model
    add_index :report_data_kdp_types, [:kdp_transaction_type, :kdp_royalty_type], unique: true, name: 'index_kdp_types'

  end
end
