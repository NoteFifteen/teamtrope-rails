class AddValidatedToPriceChangePromotions < ActiveRecord::Migration
  def change
    add_column :price_change_promotions, :validated, :bool, default: false
  end
end
