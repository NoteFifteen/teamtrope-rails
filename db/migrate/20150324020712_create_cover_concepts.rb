class CreateCoverConcepts < ActiveRecord::Migration
  def change
    create_table :cover_concepts do |t|
      t.references :project, index: true
      t.text :cover_concept_notes
      t.date :cover_art_approval_date
      t.attachment :cover_concept

      t.timestamps
    end
  end
end
