class AddRawCoverToCoverTemplates < ActiveRecord::Migration
  def change
    add_column :cover_templates, :raw_cover_file_name, :string
    add_column :cover_templates, :raw_cover_content_type, :string
    add_column :cover_templates, :raw_cover_file_size, :integer
    add_column :cover_templates, :raw_cover_updated_at, :datetime
    add_column :cover_templates, :raw_cover_direct_upload_url, :string
    add_column :cover_templates, :raw_cover_processed, :string
  end
end
