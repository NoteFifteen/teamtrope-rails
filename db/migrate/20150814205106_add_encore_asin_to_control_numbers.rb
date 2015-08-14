class AddEncoreAsinToControlNumbers < ActiveRecord::Migration
  def change
    add_column :control_numbers, :encore_asin, :string, index: true
  end
end
