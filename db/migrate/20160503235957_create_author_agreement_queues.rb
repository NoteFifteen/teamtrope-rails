class CreateAuthorAgreementQueues < ActiveRecord::Migration
  def change
    create_table :author_agreement_queues do |t|
      t.string :nickname
      t.string :file
      t.integer :status

      t.timestamps
    end
  end
end
