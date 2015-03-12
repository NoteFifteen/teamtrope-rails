class AddColumnToPriceChangePromotions < ActiveRecord::Migration
  def change
    add_column :price_change_promotions, :parse_ids, :hstore
  end
end
