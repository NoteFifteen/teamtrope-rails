class RenameTaskTabs < ActiveRecord::Migration

  Task_changes = [ { old: 'Details', new: 'Details & Synopsis' }, { old: 'Assets', new: 'Assets & Files' } ]

  def up
    Task_changes.each do |change|
      task = Task.where(tab_text: change[:old]).first
      task.update_attribute(:tab_text, change[:new]) unless task.nil?
    end
  end

  def down
    Task_changes.each do |change|
      task = Task.where(tab_text: change[:new]).first
      task.update_attribute(:tab_text, change[:old]) unless task.nil?
    end
  end

end
