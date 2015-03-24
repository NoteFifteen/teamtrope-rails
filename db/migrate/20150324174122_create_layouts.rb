class CreateLayouts < ActiveRecord::Migration
  def change
    create_table :layouts do |t|
      t.references :project, index: true
      t.string :layout_style_choice
      t.string :page_header_display_name
      t.boolean :use_pen_name_on_title
      t.string :pen_name
      t.boolean :use_pen_name_for_copyright
      t.string :exact_name_on_copyright
      t.attachment :layout_upload
      t.text :layout_notes
      t.string :layout_approved
      t.datetime :layout_approved_date
      t.json :layout_approval_issue_list
      t.integer :final_page_count

      t.timestamps
    end

    remove_columns :projects, :layout_style_choice
    remove_columns :projects, :page_header_display_name
    remove_columns :projects, :use_pen_name_on_title
    remove_columns :projects, :pen_name
    remove_columns :projects, :use_pen_name_for_copyright
    remove_columns :projects, :exact_name_on_copyright
    remove_columns :projects, :layout_upload_file_name
    remove_columns :projects, :layout_upload_content_type
    remove_columns :projects, :layout_upload_file_size
    remove_columns :projects, :layout_upload_updated_at
    remove_columns :projects, :layout_notes
    remove_columns :projects, :layout_approved
    remove_columns :projects, :layout_approved_date
    remove_columns :projects, :layout_approval_issue_list
    remove_columns :projects, :final_page_count
  end
end
