class AddImageSourceToCoverConcepts < ActiveRecord::Migration
  def change
    add_column :cover_concepts, :image_source, :string
  end
end
