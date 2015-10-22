class Tab < ActiveRecord::Base
  belongs_to :task
  belongs_to :phase

  default_scope -> { order(:order) }

  validates :task_id, presence: true

  # increment .order for all tabs subsequent tabs in the phase
  # this leaves "space" for a tab to follow this one
  def make_space_after
    subsequent_tabs = phase.tabs.joins(:task).where(
      'tabs.order >= ? and tasks.name != ?', order, task.name
    ).order('tabs.order DESC')

    subsequent_tabs.each do |tab|
      tab.order = tab.order + 1
      tab.save
    end
  end

  # make a new tab after this one, and associate the new tab with new_task
  # (should only ever come up in migrations!)
  def make_new_tab_after(new_task)
    make_space_after
    new_tab = Tab.new(
      task: new_task,
      phase: phase,
      order: order + 1
    )
    new_tab.save
    new_tab
  end
end
