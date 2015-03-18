class CreateKdpSelectEnrollments < ActiveRecord::Migration
  def change
    create_table :kdp_select_enrollments do |t|
      t.references :project, index: true
      t.integer :member_id
      t.date :enrollment_date
      t.string :update_type
      t.json :update_data

      t.timestamps
    end
    add_index :kdp_select_enrollments, :member_id
  end
end
