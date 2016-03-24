class AddModalFieldsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :modal_text, :text, default: ""
    add_column :tasks, :modal, :boolean, default: false
  end
end
