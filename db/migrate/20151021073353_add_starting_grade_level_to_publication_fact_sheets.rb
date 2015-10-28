class AddStartingGradeLevelToPublicationFactSheets < ActiveRecord::Migration
  def change
    add_column :publication_fact_sheets, :starting_grade_index, :integer
  end
end
