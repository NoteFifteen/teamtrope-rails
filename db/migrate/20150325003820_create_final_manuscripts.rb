class CreateFinalManuscripts < ActiveRecord::Migration
  def change
    create_table :final_manuscripts do |t|
      t.references :project, index: true
      t.attachment :doc
      t.attachment :pdf

      t.timestamps
    end
  end
end
