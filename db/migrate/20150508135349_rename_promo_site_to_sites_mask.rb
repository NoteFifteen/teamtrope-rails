class RenamePromoSiteToSitesMask < ActiveRecord::Migration
  def change
    rename_column :price_change_promotions, :sites, :sites_mask
  end
end
