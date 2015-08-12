class AddDirectUploadUrlToMediaKit < ActiveRecord::Migration
  def change
    add_column :media_kits, :document_direct_upload_url, :string, default: nil, after: :document_updated_at
    add_column :media_kits, :document_processed, :boolean, default: false, after: :document_direct_upload_url
  end
end
