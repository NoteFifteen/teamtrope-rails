class AddTrimSizeToLayouts < ActiveRecord::Migration
  def change
    add_column :layouts, :trim_size_w, :float, after: :pen_name
    add_column :layouts, :trim_size_h, :float, after: :trim_size_w
  end
end
