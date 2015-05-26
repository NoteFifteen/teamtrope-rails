class ConvertPrintCornersShippingZipFromIntegerToString < ActiveRecord::Migration
  def up
    change_column :print_corners, :shipping_address_zip, :string
  end

  def down
    change_column :print_corners, :shipping_address_zip, 'integer USING CAST(shipping_address_zip AS integer)'
  end


end
