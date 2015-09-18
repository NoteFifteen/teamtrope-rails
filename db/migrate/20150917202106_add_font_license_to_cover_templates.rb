class AddFontLicenseToCoverTemplates < ActiveRecord::Migration
  def change
    add_column :cover_templates, :font_license_file_name, :string
    add_column :cover_templates, :font_license_content_type, :string
    add_column :cover_templates, :font_license_file_dize, :string
    add_column :cover_templates, :font_license_updated_at, :string
    add_column :cover_templates, :font_license_direct_upload_url, :string
    add_column :cover_templates, :font_license_processed, :string
  end
end
