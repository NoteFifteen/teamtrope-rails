class AddProofreadFieldsToProject < ActiveRecord::Migration
  def change

    # Existing column
    # add_column :projects, :previously_published, :boolean

    add_column :projects, :previously_published_title, :string

    # Unused column, and I'd rather use separate fields
    remove_column :projects, :prev_publisher_and_date, :string

    add_column :projects, :previously_published_year, :integer
    add_column :projects, :previously_published_publisher, :string

    add_column :projects, :credit_request, :text
  end
end
