class CreateRightsBackRequests < ActiveRecord::Migration
  def change
    create_table :rights_back_requests do |t|
      t.references :project, index: true
      t.string     :submitted_by_name
      t.integer    :submitted_by_id
      t.string     :title
      t.string     :author
      t.text       :reason
      t.boolean    :proofed
      t.boolean    :edited
      t.boolean    :published

      t.timestamps
    end
  end
end
