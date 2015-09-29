class AddBnidToControlNumbers < ActiveRecord::Migration
  def change
    add_column :control_numbers, :bnid, :string, index: true, unique: true, :default => nil
  end
end
