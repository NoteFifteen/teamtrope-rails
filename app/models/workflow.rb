class Workflow < ActiveRecord::Base
  has_many :tasks
  belongs_to :root, class_name: "Task", foreign_key: :root_task_id

  has_many :project_type_workflows

  # Step through the workflow and build an array of tree nodes which
  # will be converted to JSON and assembled with jstree for display.
  def get_task_tree
    tree = []

    if(root != nil)
      task = root
      parent_id = '#'

      loop do
        if(task.name != nil)
          tree.append(build_node(task, parent_id))
        end

        parent_id = task.id
        task = task.next_task
        break if task == nil
      end
    end
    return tree
  end

  # Pass in a task record and the parent id and get back
  # a hash that can be converted to JSON for jstree
  def build_node (task, parent_id)
    node = {
        :id => task.id,
        :parent => parent_id,
        :text => task.display_name, # TTR-264 update display text
        :state => {
            :opened => true,
            :disabled => false,
            :selected => false,
        },
        :li_attr => [],
        :a_attr => []
    }
  end

end
