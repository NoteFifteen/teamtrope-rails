class AddCreateSpaceStoreToProject < ActiveRecord::Migration
  def change
    add_column :projects, :createspace_store_url, :string
    add_column :projects, :createspace_coupon_code, :string
  end
end
