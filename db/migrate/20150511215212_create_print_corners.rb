class CreatePrintCorners < ActiveRecord::Migration
  def change
    create_table :print_corners do |t|
      t.references :project, index: true
      t.references :user, index: true
      t.string :order_type
      t.boolean :first_order
      t.boolean :additional_order
      t.boolean :over_125
      t.boolean :billing_acceptance
      t.integer :quantity
      t.boolean :has_author_profile
      t.boolean :has_marketing_plan
      t.string :shipping_recipient
      t.string :shipping_address_street_1
      t.string :shipping_address_street_2
      t.string :shipping_address_city
      t.string :shipping_address_state
      t.integer :shipping_address_zip
      t.string :shipping_address_country
      t.string :marketing_plan_link
      t.text :marketing_copy_message
      t.string :contact_phone
      t.text :expedite_instructions

      t.timestamps
    end
  end
end
