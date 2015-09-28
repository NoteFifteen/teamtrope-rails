class AddFontListToCoverTemplates < ActiveRecord::Migration
  def change
    add_column :cover_templates, :font_list, :string
  end
end
