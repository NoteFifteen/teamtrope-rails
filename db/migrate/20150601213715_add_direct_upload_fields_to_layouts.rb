class AddDirectUploadFieldsToLayouts < ActiveRecord::Migration
  def change
    add_column :layouts, :layout_upload_direct_upload_url, :string, default: nil, after: :layout_upload_updated_at
    add_column :layouts, :layout_upload_processed, :string, default: nil, after: :layout_upload_updated_at
  end
end
