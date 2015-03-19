class CreateCoverTemplates < ActiveRecord::Migration
  def change
    create_table :cover_templates do |t|
      t.references :project, index: true
      t.attachment :ebook_front_cover
      t.attachment :createspace_cover
      t.attachment :lightning_source_cover
      t.attachment :alternative_cover

      t.timestamps
    end
  end
end
