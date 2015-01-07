class CreateCurrentSteps < ActiveRecord::Migration
  def change
    create_table :current_steps do |t|
      t.references :project, index: true
      t.references :workflow_step, index: true

      t.timestamps
    end
  end
end
