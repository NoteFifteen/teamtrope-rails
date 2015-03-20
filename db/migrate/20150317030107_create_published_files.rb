class CreatePublishedFiles < ActiveRecord::Migration
  def change
    create_table :published_files do |t|
      t.references :project, index: true
      t.attachment :mobi
      t.attachment :epub
      t.attachment :pdf
      t.date :publication_date

      t.timestamps
    end
  end
end
