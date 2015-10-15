class AddFinalCoverScreenshotToCoverTemplates < ActiveRecord::Migration
  def change
    add_column :cover_templates, :final_cover_screenshot_file_name, :string
    add_column :cover_templates, :final_cover_screenshot_content_type, :string
    add_column :cover_templates, :final_cover_screenshot_file_size, :integer
    add_column :cover_templates, :final_cover_screenshot_update_at, :timestamp
    add_column :cover_templates, :final_cover_screenshot_direct_upload_url, :string
    add_column :cover_templates, :final_cover_screenshot_processed, :string
  end
end
