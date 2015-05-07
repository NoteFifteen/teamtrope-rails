class CreateDocumentImportQueues < ActiveRecord::Migration
  def change
    create_table :document_import_queues do |t|
      t.integer :wp_id
      t.integer :attachment_id
      t.string :fieldname
      t.string :url
      t.integer :status
      t.string :dyno_id
      t.string :error

      t.timestamps
    end
  end
end
