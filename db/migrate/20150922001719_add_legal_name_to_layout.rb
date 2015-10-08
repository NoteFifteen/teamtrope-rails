class AddLegalNameToLayout < ActiveRecord::Migration
  def change
    add_column :layouts, :legal_name, :string
  end
end
