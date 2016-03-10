class AddMasterMetaDataFieldsToProjectGridTableRows < ActiveRecord::Migration
  def change
    add_column :project_grid_table_rows, :author_last_first,       :string
    add_column :project_grid_table_rows, :author_first_last,       :string
    add_column :project_grid_table_rows, :pfs_author_name,         :string
    add_column :project_grid_table_rows, :other_contributors,      :text
    add_column :project_grid_table_rows, :team_and_pct,            :text
    add_column :project_grid_table_rows, :asin,                    :string
    add_column :project_grid_table_rows, :paperback_isbn,          :string
    add_column :project_grid_table_rows, :epub_isbn,               :string
    add_column :project_grid_table_rows, :book_format,             :string
    add_column :project_grid_table_rows, :publication_date,        :date
    add_column :project_grid_table_rows, :page_count,              :integer
    add_column :project_grid_table_rows, :formatted_print_price,   :string
    add_column :project_grid_table_rows, :formatted_ebook_price,   :string
    add_column :project_grid_table_rows, :formatted_library_price, :string
    add_column :project_grid_table_rows, :bisac_one_code,          :string
    add_column :project_grid_table_rows, :bisac_one_description,   :string
    add_column :project_grid_table_rows, :bisac_two_code,          :string
    add_column :project_grid_table_rows, :bisac_two_description,   :string
    add_column :project_grid_table_rows, :bisac_three_code,        :string
    add_column :project_grid_table_rows, :bisac_three_description, :string
    add_column :project_grid_table_rows, :search_terms,            :text
    add_column :project_grid_table_rows, :description,             :text
    add_column :project_grid_table_rows, :author_bio,              :text
    add_column :project_grid_table_rows, :one_line_blurb,          :text
    add_column :project_grid_table_rows, :series_name,             :string
    add_column :project_grid_table_rows, :series_number,           :string
    add_column :project_grid_table_rows, :prefunk_enrolled,        :string
    add_column :project_grid_table_rows, :prefunk_enrollment_date, :string
  end
end
