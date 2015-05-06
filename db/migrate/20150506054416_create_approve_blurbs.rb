class CreateApproveBlurbs < ActiveRecord::Migration
  def change
    create_table :approve_blurbs do |t|
      t.references :project, index: true
      t.text :blurb_notes
      t.string :blurb_approval_decision
      t.date :blurb_approval_date

      t.timestamps
    end
  end
end
