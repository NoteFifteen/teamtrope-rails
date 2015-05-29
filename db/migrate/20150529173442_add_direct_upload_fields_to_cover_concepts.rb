class AddDirectUploadFieldsToCoverConcepts < ActiveRecord::Migration
  def change
    add_column :cover_concepts, :cover_concept_image_direct_upload_url, :string, default: nil, after: :cover_concept_updated_at
    add_column :cover_concepts, :cover_concept_image_processed, :boolean, default: false, after: :cover_concept_image_direct_upload_url

    add_column :cover_concepts, :stock_cover_image_direct_upload_url, :string, default: nil, after: :stock_cover_image_updated_at
    add_column :cover_concepts, :stock_cover_image_processed, :boolean, default: false, after: :stock_cover_image_direct_upload_url
  end
end
