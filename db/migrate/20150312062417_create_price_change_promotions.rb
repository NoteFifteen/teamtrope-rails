class CreatePriceChangePromotions < ActiveRecord::Migration
  def change
    create_table :price_change_promotions do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.float :price_promotion
      t.float :price_after_promotion
      t.integer :type_mask
      t.integer :sites
      t.references :project, index: true

      t.timestamps
    end
  end
end
