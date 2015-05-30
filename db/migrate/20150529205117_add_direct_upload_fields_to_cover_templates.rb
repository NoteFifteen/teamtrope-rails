class AddDirectUploadFieldsToCoverTemplates < ActiveRecord::Migration
  def change
    add_column :cover_templates, :alternative_cover_direct_upload_url, :string
    add_column :cover_templates, :alternative_cover_processed, :string

    add_column :cover_templates, :createspace_cover_direct_upload_url, :string
    add_column :cover_templates, :createspace_cover_processed, :string

    add_column :cover_templates, :ebook_front_cover_direct_upload_url, :string
    add_column :cover_templates, :ebook_front_cover_processed, :string

    add_column :cover_templates, :lightning_source_cover_direct_upload_url, :string
    add_column :cover_templates, :lightning_source_cover_processed, :string
  end
end
