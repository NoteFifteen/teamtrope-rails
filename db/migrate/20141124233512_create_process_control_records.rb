class CreateProcessControlRecords < ActiveRecord::Migration
  def change
    create_table :process_control_records do |t|
      t.float :days_to_complete_book
      t.integer :intro_video
      t.integer :who_can_complete
      t.boolean :is_approval_step
      t.float :days_to_complete_step
      t.integer :not_approved_go_to
      t.string :tab_text
      t.string :help_link
      t.string :step_name
      t.string :form_name
      t.string :prereq_fields
      t.integer :show_steps
      t.integer :workflow
      t.string :icon
      t.integer :phase
      t.integer :next_step
      t.boolean :is_process_step

      t.timestamps
    end
  end
end
