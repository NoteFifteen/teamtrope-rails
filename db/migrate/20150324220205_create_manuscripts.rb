class CreateManuscripts < ActiveRecord::Migration
  def change
    create_table :manuscripts do |t|
      t.references :project, index: true
      t.attachment :original
      t.attachment :edited
      t.attachment :proofed

      t.timestamps
    end
  end
end
