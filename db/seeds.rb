Phase.create!([
  {name: "Promotions", color: "green", color_value: "#AED991", icon: "icon-bullhorn", vertical_order: 7},
  {name: "Marketing", color: "green", color_value: "#AED991", icon: "icon-bullhorn", vertical_order: 6},
  {name: "Publish", color: "brown", color_value: "#8B7A6A", icon: "icon-book", vertical_order: 5},
  {name: "Design Cover", color: "blue", color_value: "#1394BB", icon: "icon-screenshot", vertical_order: 4},
  {name: "Design Layout", color: "medblu", color_value: "#0078c0", icon: "icon-screenshot", vertical_order: 3},
  {name: "Edit Content", color: "red", color_value: "#E6583E", icon: "icon-pencil", vertical_order: 2},
  {name: "Build Team", color: "yellow", color_value: "#F0D818", icon: "icon-wrench", vertical_order: 1},
  {name: "Overview", color: "white", color_value: "#eee", icon: "icon-dashboard", vertical_order: 0}
])

Role.create!([
  {name: "Author"},
  {name: "Book Manager"},
  {name: "Cover Designer"},
  {name: "Editor"},
  {name: "Proof Reader"}
])
Task.create!([
  {workflow_id: 1, next_id: nil, rejected_task_id: nil, partial: "", name: "Project Interest", icon: "", tab_text: "Project Interest", intro_video: "", days_to_complete: nil, phase_id: 7, horizontal_order: 0},
  {workflow_id: 1, next_id: nil, rejected_task_id: nil, partial: "", name: "Accept Member", icon: "", tab_text: "Accept Member", intro_video: "", days_to_complete: nil, phase_id: 7, horizontal_order: 1},
  {workflow_id: 1, next_id: nil, rejected_task_id: nil, partial: "", name: "1099 Form", icon: "", tab_text: "1099 Form", intro_video: "", days_to_complete: nil, phase_id: 7, horizontal_order: 2},
  {workflow_id: 1, next_id: nil, rejected_task_id: nil, partial: "", name: "Revenue Split", icon: "icon-money", tab_text: "Revenue Split", intro_video: "", days_to_complete: nil, phase_id: 7, horizontal_order: 3}
])
TaskPerformer.create!([
  {task_id: 2, role_id: 1},
  {task_id: 2, role_id: 2},
  {task_id: 2, role_id: 4},
  {task_id: 3, role_id: 1},
  {task_id: 3, role_id: 2},
  {task_id: 3, role_id: 3},
  {task_id: 3, role_id: 4},
  {task_id: 3, role_id: 5},
  {task_id: 4, role_id: 1}
])
Workflow.create!([
  {name: "Production", root_task_id: nil},
  {name: "Marketing", root_task_id: nil}
])
