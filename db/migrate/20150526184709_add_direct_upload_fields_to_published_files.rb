class AddDirectUploadFieldsToPublishedFiles < ActiveRecord::Migration
  def change

    add_column :published_files, :mobi_direct_upload_url, :string, default: nil
    add_column :published_files, :mobi_processed, :boolean, default: false

    add_column :published_files, :epub_direct_upload_url, :string, default: nil
    add_column :published_files, :epub_processed, :boolean, default: false

    add_column :published_files, :pdf_direct_upload_url, :string, default: nil
    add_column :published_files, :pdf_processed, :boolean, default: false

  end
end
