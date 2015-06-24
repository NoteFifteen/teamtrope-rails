class AddCoverPreviewToCoverTemplates < ActiveRecord::Migration
  def change
    add_attachment :cover_templates, :cover_preview
  end
end
