class CreatePrefunkEnrollments < ActiveRecord::Migration
  def change
    create_table :prefunk_enrollments do |t|
      t.references :project, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
