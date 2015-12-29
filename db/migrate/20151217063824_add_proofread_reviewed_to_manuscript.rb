class AddProofreadReviewedToManuscript < ActiveRecord::Migration
  def change
    add_column :manuscripts, :proofread_reviewed_content_type, :string
    add_column :manuscripts, :proofread_reviewed_file_direct_upload_url, :string
    add_column :manuscripts, :proofread_reviewed_file_name, :string
    add_column :manuscripts, :proofread_reviewed_file_processed, :boolean
    add_column :manuscripts, :proofread_reviewed_file_size, :integer
    add_column :manuscripts, :proofread_reviewed_updated_at, :datetime
  end
end
