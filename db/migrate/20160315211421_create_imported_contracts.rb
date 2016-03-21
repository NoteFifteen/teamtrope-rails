class CreateImportedContracts < ActiveRecord::Migration
  def change
    create_table :imported_contracts do |t|
      t.string :document_type
      t.text :document_signers, array: true, default: []
      t.date :document_date
      t.references :project, index: true
      t.attachment :contract
      t.string :contract_direct_upload_url
      t.boolean :contract_processed

      t.timestamps
    end
    add_index :imported_contracts, :document_type
  end
end
