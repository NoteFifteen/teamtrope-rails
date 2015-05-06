class CreateDraftBlurbs < ActiveRecord::Migration
  def change
    create_table :draft_blurbs do |t|
      t.references :project, index: true
      t.text :draft_blurb

      t.timestamps
    end
  end
end
