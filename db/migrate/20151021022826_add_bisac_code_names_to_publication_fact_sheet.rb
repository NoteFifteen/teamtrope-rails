class AddBisacCodeNamesToPublicationFactSheet < ActiveRecord::Migration
  def change
    add_column :publication_fact_sheets, :bisac_code_name_one, :string, after: :bisac_code_one
    add_column :publication_fact_sheets, :bisac_code_name_two, :string, after: :bisac_code_two
    add_column :publication_fact_sheets, :bisac_code_name_three, :string, after: :bisac_code_three
  end
end
