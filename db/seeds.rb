# coding: utf-8
# We only require an admin user name, and a password for dev.
if Rails.env == "development"
  raise "You must specify an admin user name.\n\t ex: rake db:seed admin_user=justin.jeffress password=saferthaninafile \n\t results: user: { email: \"justin.jeffress@booktrope.com\", name: \"justin.jeffress\", roles_mask: 1 }" if !ENV["admin_user"]
  raise "You must specify a password.\n\t ex: rake db:seed admin_user=justin.jeffress password=saferthaninafile \n\t results: all test users including admin will be created with ENV[\"password\"]" if !ENV["password"]
end

# seeding genres from seed-data/genres.yml
genre_seeds = Rails.root.join('db', 'seed-data', 'genres.yml')
Genre.create!(YAML::load_file(genre_seeds))

# create the imprints
Imprint.create!([
  {name: "Booktrope Editions"},
  {name: "Entice"},
  {name: "Gravity"},
  {name: "Vox Dei"},
  {name: "Forsaken"},
  {name: "Updrift"},
  {name: "Uprush"},
  {name: "Edge"}
])

# create the roles
Role.create!([
  {name: "Author", contract_description: 'The author role contract text', needs_agreement: true},
  {name: "Book Manager", contract_description: 'The Book Manager role contract text', needs_agreement: true},
  {name: "Cover Designer", contract_description: 'The Cover Designer role contract text', needs_agreement: true},
  {name: "Editor", contract_description: 'The Editor role contract text', needs_agreement: true},
  {name: "Project Manager", contract_description: 'The Projct Manager role contract text', needs_agreement: true},
  {name: "Proofreader", contract_description: 'The Proofreader role contract text', needs_agreement: true},
  {name: "Agent", contract_description: 'The Proofreader role contract text'},
  {name: "Advisor", contract_description: 'The Proofreader role contract text'},
])

workflows = {
  :production => { name: "Production", root_task_id: nil },
  :design =>     { name: "Design", root_task_id: nil },
  :marketing =>  { name: "Marketing", root_task_id: nil }
}

# creating the workflows
workflows.each do | key, wf |
  workflow = Workflow.create!(wf)
  workflows[key] = workflow
end

project_types = [
  { project_type: {name: "Standard Project", team_total_percent: 70.0}, workflows: [:production, :marketing, :design], required_roles: { "Author" => { suggested_percent: 33.0 }, "Book Manager" => { suggested_percent: 20.0 }, "Cover Designer" => { suggested_percent: 4.0 }, "Editor" => { suggested_percent: 7.0 }, "Project Manager" => { suggested_percent: 4.0 }, "Proofreader" => { suggested_percent: 2.0 }, "Agent" => { suggested_percent: 0.0 }, "Advisor" => { suggested_percent: 0.0 } } }
]

# creating project types
project_types.each do | pt |

  project_type = ProjectType.where(pt[:project_type]).first_or_create
  pt[:id] = project_type.id
  project_type.create_project_view
  pt[:workflows].each do | wf |
    project_type.project_type_workflows.create!(workflow_id: workflows[wf].id)
  end

  pt[:required_roles].each do | role_name, role_hash |
    role = Role.where(name: role_name).first
    role_hash[:role_id] = role.id
    project_type.required_roles.create!(role_hash)
  end
end

# A hash mapping the role name to it's id in the db.
# This is an optimzation so we don't have to look up the role each iteration
# of the loop.
role_map = Hash[*Role.all.map{ | role | { role.name => role.id } }.collect{ |h| h.to_a}.flatten]

tasks =  {

  :manuscript_development =>        { task: { workflow_id: :production,  next_id: :original_manuscript, rejected_task_id: nil,   partial: "manuscript_development",   name: "Manuscript Development",    icon: "icon-bookmark",    tab_text: "Man Development",    intro_video: "",  days_to_complete: nil }, root: true, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Edit Complete Date", "Project Details", "Revenue Split", "Team Change",  "Artwork Rights Request", "Team"], performers: ["Author"]},
  :original_manuscript =>           { task: { workflow_id: :production,  next_id: :first_pass_edit,   rejected_task_id: nil,   partial: "original_manuscript",      name: "Original Manuscript",       icon: "icon-bookmark",    tab_text: "Orig. Man.",         intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Edit Complete Date", "Project Details", "Revenue Split", "Team Change",  "Artwork Rights Request", "Team"], performers: ["Author"]},
  :first_pass_edit =>               { task: { workflow_id: :production,  next_id: :edited_manuscript,   rejected_task_id: nil,   partial: "first_pass_edit",      name: "First Pass Edit",       icon: "icon-bookmark",    tab_text: "First Pass Edit",         intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Edit Complete Date", "Project Details", "Revenue Split", "Team Change",  "Artwork Rights Request", "Team"], performers: ["Editor"]},
  :edited_manuscript =>             { task: { workflow_id: :production,  next_id: :proofed_manuscript,    rejected_task_id: nil,   partial: "edited_manuscript",        name: "Edited Manuscript",         icon: "icon-edit",        tab_text: "Edited Manuscript",  intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Edit Complete Date", "Project Details", "Revenue Split", "Team Change", "Submit Edited",  "Artwork Rights Request", "Team"], performers: ['Author', 'Editor', 'Project Manager']},
  :proofed_manuscript =>          { task: { workflow_id: :production,  next_id: :proofread_complete,    rejected_task_id: nil,   partial: "proofed_manuscript",        name: "Proofed Manuscript",         icon: "icon-edit",        tab_text: "Proofed Manuscript",  intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Edit Complete Date", "Project Details", "Revenue Split", "Team Change", "Submit Edited",  "Artwork Rights Request", "Team"], performers: ['Author']},
  :proofread_complete =>              { task: { workflow_id: :production,  next_id: :choose_style,        rejected_task_id: nil,   partial: "proofread_complete",         name: "Proofread Complete",        icon: "icon-ok-sign",     tab_text: "Proofread Complete", intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Project Details", "Revenue Split", "Team Change",  "Team", "Control Numbers", "Artwork Rights Request"], performers: ['Author']},
  :choose_style =>                  { task: { workflow_id: :production,  next_id: :upload_layout,       rejected_task_id: nil,   partial: "choose_style",             name: "Choose Style",              icon: "icon-adjust",      tab_text: "Choose Style",       intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Project Details", "Revenue Split", "Team Change", "Control Numbers",  "Team", "Artwork Rights Request"], performers: ['Author', 'Project Manager']},
  :upload_layout =>                 { task: { workflow_id: :production,  next_id: :approve_layout,      rejected_task_id: nil,   partial: "upload_layout",            name: "Upload Layout",             icon: "icon-cloud-upload",tab_text: "Upload Layout",      intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Project Details", "Revenue Split", "Team Change", "Upload Layout", "Team", "Artwork Rights Request"], performers: []},
  :approve_layout =>                { task: { workflow_id: :production,  next_id: :check_imprint,       rejected_task_id: nil,   partial: "approve_layout",           name: "Approve Layout",            icon: "icon-thumbs-up",   tab_text: "Approve Layout",     intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Project Details", "Team", "Revenue Split", "Team Change",  "Artwork Rights Request", "Approve Layout"], performers: ['Author']},
  :check_imprint =>                 { task: { workflow_id: :production,  next_id: :page_count,          rejected_task_id: nil,   partial: "check_imprint",            name: "Check Imprint",             icon: "icon-cogs",        tab_text: "Check Imprint",      intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Project Details", "Team", "Revenue Split", "Team Change",  "Artwork Rights Request", "Check Imprint"],  performers: []},
  :page_count =>                    { task: { workflow_id: :production,  next_id: :final_manuscript,    rejected_task_id: nil,   partial: "page_count",               name: "Page Count",                icon: "icon-list-ol",     tab_text: "Page Count",         intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Final Page Count", "Project Details", "Revenue Split", "Team Change", "Team", "Artwork Rights Request"], performers: []},
  :final_manuscript =>              { task: { workflow_id: :production,  next_id: :publish_book,        rejected_task_id: nil,   partial: "final_manuscript",         name: "Final Manuscript",          icon: "icon-bookmark",    tab_text: "Final Manuscript",   intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Final Manuscript", "Project Details", "Revenue Split", "Team Change", "Team", "Artwork Rights Request"], performers: []},
  :publish_book =>                  { task: { workflow_id: :production,  next_id: :production_complete, rejected_task_id: nil,   partial: "publish_book",             name: "Publish Book",              icon: "icon-star",        tab_text: "Publish Book",       intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Project Details", "Publish Book", "Revenue Split", "Team Change", "Team", "Production Expense", "Artwork Rights Request", "Control Numbers"], performers: []},
  :production_complete =>           { task: { workflow_id: :production,  next_id: nil,                  rejected_task_id: nil,   partial: nil,                        name: "Production Complete",       icon: "",                 tab_text: "",                   intro_video: "",  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Activity", "Blog Tour", "Media Kit", "Project Details", "Promos", "Revenue Split", "Team Change", "Print", "Control Numbers", "Analytics", "Artwork Rights Request", "Team",  "Marketing Expense", "KDP Select Enrollment", "KDP Select Update"]},

  :upload_cover_concept =>          { task: { workflow_id: :design,      next_id: :approve_cover_art,      rejected_task_id: nil,                     partial: "upload_cover_concept",     name: "Cover Concept",        icon: "icon-bookmark",    tab_text: "Concept",  intro_video: "",  days_to_complete: nil }, root: true, unlocked: ["Request Image", "Add Image"], performers: ['Cover Designer', 'Project Manager']},
  :approve_cover_art =>             { task: { workflow_id: :design,      next_id: :upload_cover_templates, rejected_task_id: :upload_cover_concept,   partial: "approve_cover_art",        name: "Approve Cover Art",    icon: "icon-thumbs-up",   tab_text: "Approve Cover",  intro_video: "",  days_to_complete: nil }, unlocked: ["Request Image", "Add Image", "Cover Concept"], performers: []},
  :upload_cover_templates =>        { task: { workflow_id: :design,      next_id: :final_cover_approval,   rejected_task_id: nil,                     partial: "upload_cover_templates",   name: "Final Covers",         icon: "icon-cloud-upload",tab_text: "Final",   intro_video: "",  days_to_complete: nil }, unlocked: ["Request Image", "Add Image", "Cover Concept"], performers: ['Author', 'Cover Designer', 'Project Manager']},
  :update_psd =>                    { task: { workflow_id: :design,      next_id: nil,                     rejected_task_id: nil,                     partial: "update_psd",               name: "Update PSD",           icon: "icon-cloud-upload",tab_text: "Update PSD",   intro_video: "",  days_to_complete: nil }, unlocked: ["Request Image", "Add Image", "Approve Final"], performers: ['Author', 'Cover Designer', 'Project Manager']},
  :final_cover_approval =>          { task: { workflow_id: :design,      next_id: :design_complete,        rejected_task_id: :upload_cover_templates, partial: "approve_final_cover",      name: "Approve Final Covers", icon: "icon-thumbs-up",   tab_text: "Approve Final",  intro_video: "",  days_to_complete: nil }, unlocked: ["Request Image", "Add Image"], performers: ['Author', 'Cover Designer', 'Project Manager']},
  :design_complete =>               { task: { workflow_id: :design,      next_id: nil,                     rejected_task_id: nil,                     partial: nil,                        name: "Design Complete",      icon: "",                 tab_text: "",               intro_video: "",  days_to_complete: nil }, unlocked: []},

  :submit_blurb =>                                  { task: { workflow_id: :marketing,   next_id: :approve_blurb,                 rejected_task_id: nil,           partial: "submit_blurb",                  name: "Submit Blurb",       icon: "icon-bookmark",  tab_text: "Submit Blurb",   intro_video: "" ,  days_to_complete: nil }, root: true, unlocked: ['Update Genre'], performers: ['Author', 'Book Manager', 'Project Manager']},
  :approve_blurb =>                   { task: { workflow_id: :marketing,   next_id: :submit_publication_fact_sheet, rejected_task_id: :submit_blurb, partial: "approve_blurb",                 name: "Approve Blurb",      icon: "icon-thumbs-up", tab_text: "Approve Blurb",  intro_video: "" ,  days_to_complete: nil }, unlocked: ['Update Genre'], performers: ['Author', 'Book Manager', 'Project Manager']},
  :submit_publication_fact_sheet => { task: { workflow_id: :marketing,   next_id: :marketing_complete,            rejected_task_id: nil,           partial: "submit_publication_fact_sheet", name: "Submit PFS",         icon: "icon-bookmark",  tab_text: "Publication Fact Sheet",     intro_video: "" ,  days_to_complete: nil }, unlocked: ['Update Genre'], performers: ['Author', 'Book Manager', 'Project Manager']},
  :marketing_complete =>            { task: { workflow_id: :marketing,   next_id: nil,                            rejected_task_id: nil,           partial: nil,                             name: "Marketing Complete", icon: "",               tab_text: "",               intro_video: "" ,  days_to_complete: nil }, unlocked: ['Update Genre']},

  :accept_member =>                 { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "accept_member",           name: "Accept Member",             icon: "icon-thumbs-up",   tab_text: "Accept Member",      intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author']},
  :form_1099 =>                     { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "form_1099",               name: "1099 Form",                 icon: "icon-cogs",        tab_text: "1099 Form",          intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['*']},
  :revenue_split =>                 { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "revenue_split",           name: "Revenue Split",             icon: "icon-money",       tab_text: "Revenue Split",      intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author']},
  :project_details =>               { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "project_details",         name: "Project Details",           icon: "icon-file-alt",    tab_text: "Details & Synopsis", intro_video: "" ,  days_to_complete: nil, team_only: false }, unlocked: []},
  :assets =>                        { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "assets",                  name: "Assets",                    icon: "icon-folder-open", tab_text: "Assets & Files",     intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['*']},
  :team =>                          { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "team",                    name: "Team",                      icon: "icon-group",       tab_text: "Team",               intro_video: "" ,  days_to_complete: nil, team_only: false }, unlocked: []},
  :analytics =>                     { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "analytics",               name: "Analytics",                 icon: "icon-bar-chart",   tab_text: "Analytics",          intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['*']},
  :control_numbers =>               { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "control_numbers",         name: "Control Numbers",           icon: "icon-cogs",        tab_text: "Ctrl No.",           intro_video: "" ,  days_to_complete: nil }, unlocked: []},
  :activity =>                      { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "activity",                name: "Activity",                  icon: "fa-check-circle",  tab_text: "Activity",           intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['*']},
  :request_image =>                 { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "request_image",           name: "Request Image",             icon: "icon-adjust",      tab_text: "Request Img",        intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Cover Designer', 'Project Manager']},
  :update_genre =>                  { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: 'update_genre',            name: 'Update Genre',              icon: 'icon-magic',       tab_text: 'Update Genre',       intro_video: "" ,  days_to_complete: nil }, unlocked: []},
  :add_image =>                     { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "add_image",               name: "Add Image",                 icon: "icon-adjust",      tab_text: "Add Img",            intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: []},
  :artwork_rights =>                { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "artwork_rights",          name: "Artwork Rights Request",    icon: "fa-meh-o",         tab_text: "Artwork Rights",     intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Book Manager', 'Project Manager']},
  :media_kit =>                     { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "media_kit",               name: "Media Kit",                 icon: "icon-comment",     tab_text: "Media Kit",          intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Book Manager']},
  :print_corner =>                  { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "print_corner",            name: "Print",                     icon: "icon-envelope",    tab_text: "Print",              intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager']},
  :blog_tour =>                     { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "blog_tour",               name: "Blog Tour",                 icon: "icon-money",       tab_text: "Blog Tour",          intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager']},
  :price_promotion =>               { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "price_promotion",         name: "Promos",                    icon: "icon-money",       tab_text: "Pricing and Promos", intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager']},
  :kdp_select_enrollment =>         { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "kdp_select_enrollment",   name: "KDP Select",                icon: "icon-bookmark",    tab_text: "KDP Select",         intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager']},
  :kdp_select_update =>             { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "kdp_select_update",       name: "KDP Update",                icon: "icon-bookmark",    tab_text: "KDP Update",         intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager']},
  :marketing_expense =>             { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "marketing_expense",       name: "Marketing Expense",         icon: "icon-money",       tab_text: "Mkt $",              intro_video: "" ,  days_to_complete: nil }, unlocked: []},
  :production_expense =>            { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "production_expense",      name: "Production Expense",        icon: "icon-money",       tab_text: "Prod $",             intro_video: "" ,  days_to_complete: nil }, unlocked: []},
  :team_change =>                   { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "team_change",             name: "Team Change",               icon: "icon-bookmark",    tab_text: "Team Change",        intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author']},
}

# creating tasks
tasks.each do | key, t |
  t[:task][:workflow_id] = workflows[t[:task][:workflow_id]].id if t[:task][:workflow_id]
  task = Task.create!(t[:task])
  task.workflow.update_attributes(root_task_id: task.id) if t.has_key?(:root) && t[:root]
  t[:id] = task.id
end

# chicken or the egg? depending on the order we create tasks the next task (next_id) might
# not exist, so we add the unlocked tasks after.
Task.all.each do | task |
  next unless task.partial? #the only tasks that don't have partials are the last of a workflow

  next if tasks[task.partial.to_sym].nil?
  if tasks[task.partial.to_sym][:task][:next_id]
    task.next_id = tasks[tasks[task.partial.to_sym][:task][:next_id]][:id]
    task.save
  end

  # Handle the rejected tasks
  if tasks[task.partial.to_sym][:task][:rejected_task_id]
    task.rejected_task_id = tasks[tasks[task.partial.to_sym][:task][:rejected_task_id]][:id]
    task.save
  end
end

tasks.each do | key , t |
  # loading the task (we cache the id after we create it.)
  task = Task.find(t[:id])

  # create UnlockedTask associations
  if t[:unlocked].try(:count)
    Task.where(name: t[:unlocked]).each do | unlocked_task |
      #UnlockedTask.create!({ task_id: t[:id],  unlocked_task_id: unlocked_task.id})
      task.unlocked_tasks.create!(unlocked_task: unlocked_task)
    end
  end

  # creating the task performers
  if t[:performers].try(:count)
    performers = t[:performers]
    performers = role_map.values if performers.count == 1 && performers.first == '*'
    performers.each do | performer |
      task.task_performers.create!(role_id: role_map[performer])
    end
  end
end

# we only have one project_view for the moment so we are safe to hardcode the id to 1
# but if/when we create new ones we will need to do something like the tasks/workflow_id
#creating phases
[
  { phase: { project_view_id: 1, name: "Overview",       color: "white",   color_value: "#eee",    icon: "icon-dashboard", order: 0},  tabs: [ {task_id: :project_details,        order: 1}, {task_id: :assets,                 order: 2}, {task_id: :team,              order: 3}, {task_id: :analytics,          order: 4}, {task_id: :control_numbers, order: 5}, {task_id: :activity, order: 6}]},
  { phase: { project_view_id: 1, name: "Build Team",     color: "yellow",  color_value: "#F0D818", icon: "icon-wrench", order: 1},     tabs: [ {task_id: :accept_member,          order: 1}, {task_id: :form_1099,              order: 2}, {task_id: :revenue_split,     order: 3}, {task_id: :team_change,        order: 4}]},
  { phase: { project_view_id: 1, name: "Edit Content",   color: "red",     color_value: "#E6583E", icon: "icon-pencil", order: 2},     tabs: [ {task_id: :manuscript_development, order: 1}, {task_id: :original_manuscript,    order: 2}, {task_id: :first_pass_edit,    order: 3}, {task_id: :edited_manuscript, order: 4}, {task_id: :proofed_manuscript,    order: 5}, {task_id: :proofread_complete,   order: 6}]},
  { phase: { project_view_id: 1, name: "Marketing Prep", color: "green",   color_value: "#AED991", icon: "icon-bullhorn", order: 3},   tabs: [ {task_id: :submit_blurb,           order: 1}, {task_id: :approve_blurb,          order: 2}, {task_id: :submit_publication_fact_sheet, order: 3}, {task_id: :update_genre, order: 5}]},
  { phase: { project_view_id: 1, name: "Design Layout",  color: "medblue", color_value: "#0078c0", icon: "icon-screenshot", order: 4}, tabs: [ {task_id: :choose_style,           order: 1}, {task_id: :upload_layout,          order: 2}, {task_id: :approve_layout,    order: 3}, {task_id: :check_imprint, order: 4}, {task_id: :page_count,         order: 5}]},
  { phase: { project_view_id: 1, name: "Design Cover",   color: "blue",    color_value: "#1394BB", icon: "icon-screenshot", order: 5}, tabs: [ {task_id: :upload_cover_concept,   order: 1}, {task_id: :approve_cover_art,      order: 2}, {task_id: :request_image,     order: 3}, {task_id: :add_image,          order: 4}, {task_id: :upload_cover_templates, order: 5}, {task_id: :update_psd, order: 6}, {task_id: :final_cover_approval, order: 7}, {task_id: :artwork_rights, order: 8}]},
  { phase: { project_view_id: 1, name: "Publish",        color: "brown",   color_value: "#8B7A6A", icon: "icon-book", order: 6},       tabs: [ {task_id: :final_manuscript,       order: 1}, {task_id: :publish_book,           order: 2}]},
  { phase: { project_view_id: 1, name: "Marketing",      color: "green",   color_value: "#AED991", icon: "icon-bullhorn", order: 7},   tabs: [ {task_id: :media_kit,              order: 1}, {task_id: :print_corner,           order: 2}, {task_id: :blog_tour,         order: 3}, {task_id: :price_promotion,    order: 4}]},
  { phase: { project_view_id: 1, name: "Promotions",     color: "green",   color_value: "#AED991", icon: "icon-bullhorn", order: 8},   tabs: [ {task_id: :kdp_select_enrollment,  order: 1}, {task_id: :kdp_select_update,      order: 2}, {task_id: :marketing_expense, order: 3}, {task_id: :production_expense, order: 4}]}
].each do | phase_hash |
  phase = Phase.create! phase_hash[:phase]
  phase_hash[:tabs].each do | tab_hash |
    tab_hash[:task_id] = tasks[tab_hash[:task_id]][:id]
    phase.tabs.create! tab_hash
  end
end

##########################################################################################
# Development only
# The following data is for development only do not create these objects for production
##########################################################################################
if Rails.env == "development"
  # creating projects
  Project.create!([
    {stock_image_request_link: "", previously_published: nil, proofed_word_count: nil, teamroom_link: "", publication_date: nil, title: "Between Boyfriends by Sárka-Jonae Miller", final_title: "Between Boyfriends", special_text_treatment: "", has_sub_chapters: nil, has_index: nil, non_standard_size: nil, has_internal_illustrations: nil, color_interior: nil, childrens_book: nil, edit_complete_date: nil, project_type_id: 1},
    {stock_image_request_link: "", previously_published: nil, proofed_word_count: nil, teamroom_link: "", publication_date: nil, title: "Atolovus by David Covenant",               final_title: "Atolovus",           special_text_treatment: "", has_sub_chapters: nil, has_index: nil, non_standard_size: nil, has_internal_illustrations: nil, color_interior: nil, childrens_book: nil, edit_complete_date: nil, project_type_id: 1}
  ])

  Project.all.each do | project |
    pgtr = project.build_project_grid_table_row(title: project.title)
    project.project_type.workflows.each do | workflow |
      ct = project.current_tasks.create(task_id: workflow.root.id)
      pgtr[workflow.name.downcase.gsub(/ /, "_") + "_task_id"] = workflow.root.id
      pgtr[workflow.name.downcase.gsub(/ /, "_") + "_task_name"] = workflow.root.name
    end
    pgtr.save
  end

  # turning off callbacks so we don't send CTAs when we create test TeamMemberships
  ActiveRecord::Base.skip_callbacks = true
  TeamMembership.create!([
    {project_id: 1, member_id: 1,  role_id: 1, percentage: 33.0 },
    {project_id: 1, member_id: 3,  role_id: 2, percentage: 20.0 },
    {project_id: 1, member_id: 8,  role_id: 3, percentage: 4.0 },
    {project_id: 1, member_id: 11, role_id: 4, percentage: 7.0 },
    {project_id: 1, member_id: 6,  role_id: 5, percentage: 2.0 },
    {project_id: 1, member_id: 12, role_id: 6, percentage: 4.0 },
    {project_id: 2, member_id: 8,  role_id: 1, percentage: 33.0 },
    {project_id: 2, member_id: 7,  role_id: 2, percentage: 20.0 },
    {project_id: 2, member_id: 12, role_id: 4, percentage: 7.0 }
  ])
  ActiveRecord::Base.skip_callbacks = false

  HellosignDocumentType.create!(
    name: 'Creative Team Agreement',
    subject: 'New Creative Team Agreement',
    message: 'Please sign this document using HelloSign. Thank you.',
    template_id: "89b8470207a85ea8ea580fd8f0ac89fc0ca302fc",
    signers: [
      {"email_address"=>"#{ENV['admin_user']}+ken@booktrope.com", "name"=>"Ken Shear", "role"=>"Booktrope-CEO"}
    ],
    ccs: [
      {"email_address"=>"#{ENV['admin_user']}+intake@booktrope.com", "role"=>"Intake Manager"},
      {"email_address"=>"#{ENV['admin_user']}+hr@booktrope.com", "role"=>"HR/Accounting"}
    ]
  )

  users = [
    {email: "#{ENV["admin_user"]}@booktrope.com", name: "#{ENV["admin_user"]}", password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 5}, # Author + Staff
    {email: "#{ENV["admin_user"]}+charles.buckowski@booktrope.com",   name: "Charles Buckowski",   password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 260}, # Author
    {email: "#{ENV["admin_user"]}+stephen.king@booktrope.com",        name: "Stephen King",        password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 8},   # Book Manager
    {email: "#{ENV["admin_user"]}+michael.crichton@booktrope.com",    name: "Michael Crichton",    password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 36},  # Author + Editor
    {email: "#{ENV["admin_user"]}+issac.asimov@booktrope.com",        name: "Issac Asimov",        password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 32},  # Editor
    {email: "#{ENV["admin_user"]}+arthur.c.clark@booktrope.com",      name: "Arthur C. Clark",     password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 52},  # Book Manager + Project Manager
    {email: "#{ENV["admin_user"]}+j.r.r.tolkien@booktrope.com",       name: "J.R.R. Tolkien",      password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 136}, # Book Manager + Proofreader
    {email: "#{ENV["admin_user"]}+chuck.palahniuk@booktrope.com",     name: "Chuck Palahniuk",     password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 20},  # Author + Cover Designer
    {email: "#{ENV["admin_user"]}+kurt.vonnegut@booktrope.com",       name: "Kurt Vonnegut",       password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 580}, # Author + Project Manager + Observer
    {email: "#{ENV["admin_user"]}+mark.twain@booktrope.com",          name: "Mark Twain",          password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 40},  # Editor + Book Manager
    {email: "#{ENV["admin_user"]}+charles.dickens@booktrope.com",     name: "Charles Dickens",     password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 164}, # Author + Editor + Proofreader
    {email: "#{ENV["admin_user"]}+william.shakespeare@booktrope.com", name: "William Shakespeare", password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 160}, # Editor + Proofreader
    {email: "#{ENV["admin_user"]}+jack.kerouac@booktrope.com",        name: "Jack Kerouac",        password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 48},  # Editor + Cover Designer
    {email: "#{ENV["admin_user"]}+truman.capote@booktrope.com",       name: "Truman Capote",       password: ENV["password"], password_confirmation: ENV["password"], roles_mask: 192}, # Project Manager + Proofreader
  ]
  users.each do | u |
    user = User.create!(u)
    user.create_profile
    user.uid = user.id
    user.save
  end


  # Not really necessary for most things, but since it's only getting added in a Migration and we may want this for local development
  # I'm including this country lookup table that's part of the sales reporting / BIME integration project.
  # # Populate the countries!
  ReportDataCountry.create!([
      { name: "Afghanistan", code_iso: "AF", code_un: "AFG" },
      { name: "Albania", code_iso: "AL", code_un: "ALB" },
      { name: "Algeria", code_iso: "DZ", code_un: "DZA" },
      { name: "American Samoa", code_iso: "AS", code_un: "ASM" },
      { name: "Andorra", code_iso: "AD", code_un: "AND" },
      { name: "Angola", code_iso: "AO", code_un: "AGO" },
      { name: "Anguilla", code_iso: "AI", code_un: "AIA" },
      { name: "Antarctica", code_iso: "AQ", code_un: "ATA" },
      { name: "Antigua and Barbuda", code_iso: "AG", code_un: "ATG" },
      { name: "Argentina", code_iso: "AR", code_un: "ARG" },
      { name: "Armenia", code_iso: "AM", code_un: "ARM" },
      { name: "Aruba", code_iso: "AW", code_un: "ABW" },
      { name: "Australia", code_iso: "AU", code_un: "AUS" },
      { name: "Austria", code_iso: "AT", code_un: "AUT" },
      { name: "Azerbaijan", code_iso: "AZ", code_un: "AZE" },
      { name: "Bahamas", code_iso: "BS", code_un: "BHS" },
      { name: "Bahrain", code_iso: "BH", code_un: "BHR" },
      { name: "Bangladesh", code_iso: "BD", code_un: "BGD" },
      { name: "Barbados", code_iso: "BB", code_un: "BRB" },
      { name: "Belarus", code_iso: "BY", code_un: "BLR" },
      { name: "Belgium", code_iso: "BE", code_un: "BEL" },
      { name: "Belize", code_iso: "BZ", code_un: "BLZ" },
      { name: "Benin", code_iso: "BJ", code_un: "BEN" },
      { name: "Bermuda", code_iso: "BM", code_un: "BMU" },
      { name: "Bhutan", code_iso: "BT", code_un: "BTN" },
      { name: "Bolivia", code_iso: "BO", code_un: "BOL" },
      { name: "Bonaire", code_iso: "BQ", code_un: "BES" },
      { name: "Bosnia and Herzegovina", code_iso: "BA", code_un: "BIH" },
      { name: "Botswana", code_iso: "BW", code_un: "BWA" },
      { name: "Bouvet Island", code_iso: "BV", code_un: "BVT" },
      { name: "Brazil", code_iso: "BR", code_un: "BRA" },
      { name: "British Indian Ocean Territory", code_iso: "IO", code_un: "IOT" },
      { name: "Brunei Darussalam", code_iso: "BN", code_un: "BRN" },
      { name: "Bulgaria", code_iso: "BG", code_un: "BGR" },
      { name: "Burkina Faso", code_iso: "BF", code_un: "BFA" },
      { name: "Burundi", code_iso: "BI", code_un: "BDI" },
      { name: "Cambodia", code_iso: "KH", code_un: "KHM" },
      { name: "Cameroon", code_iso: "CM", code_un: "CMR" },
      { name: "Canada", code_iso: "CA", code_un: "CAN" },
      { name: "Cape Verde", code_iso: "CV", code_un: "CPV" },
      { name: "Cayman Islands", code_iso: "KY", code_un: "CYM" },
      { name: "Central African Republic", code_iso: "CF", code_un: "CAF" },
      { name: "Chad", code_iso: "TD", code_un: "TCD" },
      { name: "Chile", code_iso: "CL", code_un: "CHL" },
      { name: "China", code_iso: "CN", code_un: "CHN" },
      { name: "Christmas Island", code_iso: "CX", code_un: "CXR" },
      { name: "Cocos (Keeling) Islands", code_iso: "CC", code_un: "CCK" },
      { name: "Colombia", code_iso: "CO", code_un: "COL" },
      { name: "Comoros", code_iso: "KM", code_un: "COM" },
      { name: "Congo", code_iso: "CG", code_un: "COG" },
      { name: "Democratic Republic of the Congo", code_iso: "CD", code_un: "COD" },
      { name: "Cook Islands", code_iso: "CK", code_un: "COK" },
      { name: "Costa Rica", code_iso: "CR", code_un: "CRI" },
      { name: "Croatia", code_iso: "HR", code_un: "HRV" },
      { name: "Cuba", code_iso: "CU", code_un: "CUB" },
      { name: "CuraÃ§ao", code_iso: "CW", code_un: "CUW" },
      { name: "Cyprus", code_iso: "CY", code_un: "CYP" },
      { name: "Czech Republic", code_iso: "CZ", code_un: "CZE" },
      { name: "CÃ´te d'Ivoire", code_iso: "CI", code_un: "CIV" },
      { name: "Denmark", code_iso: "DK", code_un: "DNK" },
      { name: "Djibouti", code_iso: "DJ", code_un: "DJI" },
      { name: "Dominica", code_iso: "DM", code_un: "DMA" },
      { name: "Dominican Republic", code_iso: "DO", code_un: "DOM" },
      { name: "Ecuador", code_iso: "EC", code_un: "ECU" },
      { name: "Egypt", code_iso: "EG", code_un: "EGY" },
      { name: "El Salvador", code_iso: "SV", code_un: "SLV" },
      { name: "Equatorial Guinea", code_iso: "GQ", code_un: "GNQ" },
      { name: "Eritrea", code_iso: "ER", code_un: "ERI" },
      { name: "Estonia", code_iso: "EE", code_un: "EST" },
      { name: "Ethiopia", code_iso: "ET", code_un: "ETH" },
      { name: "Falkland Islands (Malvinas)", code_iso: "FK", code_un: "FLK" },
      { name: "Faroe Islands", code_iso: "FO", code_un: "FRO" },
      { name: "Fiji", code_iso: "FJ", code_un: "FJI" },
      { name: "Finland", code_iso: "FI", code_un: "FIN" },
      { name: "France", code_iso: "FR", code_un: "FRA" },
      { name: "French Guiana", code_iso: "GF", code_un: "GUF" },
      { name: "French Polynesia", code_iso: "PF", code_un: "PYF" },
      { name: "French Southern Territories", code_iso: "TF", code_un: "ATF" },
      { name: "Gabon", code_iso: "GA", code_un: "GAB" },
      { name: "Gambia", code_iso: "GM", code_un: "GMB" },
      { name: "Georgia", code_iso: "GE", code_un: "GEO" },
      { name: "Germany", code_iso: "DE", code_un: "DEU" },
      { name: "Ghana", code_iso: "GH", code_un: "GHA" },
      { name: "Gibraltar", code_iso: "GI", code_un: "GIB" },
      { name: "Greece", code_iso: "GR", code_un: "GRC" },
      { name: "Greenland", code_iso: "GL", code_un: "GRL" },
      { name: "Grenada", code_iso: "GD", code_un: "GRD" },
      { name: "Guadeloupe", code_iso: "GP", code_un: "GLP" },
      { name: "Guam", code_iso: "GU", code_un: "GUM" },
      { name: "Guatemala", code_iso: "GT", code_un: "GTM" },
      { name: "Guernsey", code_iso: "GG", code_un: "GGY" },
      { name: "Guinea", code_iso: "GN", code_un: "GIN" },
      { name: "Guinea-Bissau", code_iso: "GW", code_un: "GNB" },
      { name: "Guyana", code_iso: "GY", code_un: "GUY" },
      { name: "Haiti", code_iso: "HT", code_un: "HTI" },
      { name: "Heard Island and McDonald Mcdonald Islands", code_iso: "HM", code_un: "HMD" },
      { name: "Holy See (Vatican City State)", code_iso: "VA", code_un: "VAT" },
      { name: "Honduras", code_iso: "HN", code_un: "HND" },
      { name: "Hong Kong", code_iso: "HK", code_un: "HKG" },
      { name: "Hungary", code_iso: "HU", code_un: "HUN" },
      { name: "Iceland", code_iso: "IS", code_un: "ISL" },
      { name: "India", code_iso: "IN", code_un: "IND" },
      { name: "Indonesia", code_iso: "ID", code_un: "IDN" },
      { name: "Iran, Islamic Republic of", code_iso: "IR", code_un: "IRN" },
      { name: "Iraq", code_iso: "IQ", code_un: "IRQ" },
      { name: "Ireland", code_iso: "IE", code_un: "IRL" },
      { name: "Isle of Man", code_iso: "IM", code_un: "IMN" },
      { name: "Israel", code_iso: "IL", code_un: "ISR" },
      { name: "Italy", code_iso: "IT", code_un: "ITA" },
      { name: "Jamaica", code_iso: "JM", code_un: "JAM" },
      { name: "Japan", code_iso: "JP", code_un: "JPN" },
      { name: "Jersey", code_iso: "JE", code_un: "JEY" },
      { name: "Jordan", code_iso: "JO", code_un: "JOR" },
      { name: "Kazakhstan", code_iso: "KZ", code_un: "KAZ" },
      { name: "Kenya", code_iso: "KE", code_un: "KEN" },
      { name: "Kiribati", code_iso: "KI", code_un: "KIR" },
      { name: "Korea, Democratic People's Republic of", code_iso: "KP", code_un: "PRK" },
      { name: "Korea, Republic of", code_iso: "KR", code_un: "KOR" },
      { name: "Kuwait", code_iso: "KW", code_un: "KWT" },
      { name: "Kyrgyzstan", code_iso: "KG", code_un: "KGZ" },
      { name: "Lao People's Democratic Republic", code_iso: "LA", code_un: "LAO" },
      { name: "Latvia", code_iso: "LV", code_un: "LVA" },
      { name: "Lebanon", code_iso: "LB", code_un: "LBN" },
      { name: "Lesotho", code_iso: "LS", code_un: "LSO" },
      { name: "Liberia", code_iso: "LR", code_un: "LBR" },
      { name: "Libya", code_iso: "LY", code_un: "LBY" },
      { name: "Liechtenstein", code_iso: "LI", code_un: "LIE" },
      { name: "Lithuania", code_iso: "LT", code_un: "LTU" },
      { name: "Luxembourg", code_iso: "LU", code_un: "LUX" },
      { name: "Macao", code_iso: "MO", code_un: "MAC" },
      { name: "Macedonia, the Former Yugoslav Republic of", code_iso: "MK", code_un: "MKD" },
      { name: "Madagascar", code_iso: "MG", code_un: "MDG" },
      { name: "Malawi", code_iso: "MW", code_un: "MWI" },
      { name: "Malaysia", code_iso: "MY", code_un: "MYS" },
      { name: "Maldives", code_iso: "MV", code_un: "MDV" },
      { name: "Mali", code_iso: "ML", code_un: "MLI" },
      { name: "Malta", code_iso: "MT", code_un: "MLT" },
      { name: "Marshall Islands", code_iso: "MH", code_un: "MHL" },
      { name: "Martinique", code_iso: "MQ", code_un: "MTQ" },
      { name: "Mauritania", code_iso: "MR", code_un: "MRT" },
      { name: "Mauritius", code_iso: "MU", code_un: "MUS" },
      { name: "Mayotte", code_iso: "YT", code_un: "MYT" },
      { name: "Mexico", code_iso: "MX", code_un: "MEX" },
      { name: "Micronesia, Federated States of", code_iso: "FM", code_un: "FSM" },
      { name: "Moldova, Republic of", code_iso: "MD", code_un: "MDA" },
      { name: "Monaco", code_iso: "MC", code_un: "MCO" },
      { name: "Mongolia", code_iso: "MN", code_un: "MNG" },
      { name: "Montenegro", code_iso: "ME", code_un: "MNE" },
      { name: "Montserrat", code_iso: "MS", code_un: "MSR" },
      { name: "Morocco", code_iso: "MA", code_un: "MAR" },
      { name: "Mozambique", code_iso: "MZ", code_un: "MOZ" },
      { name: "Myanmar", code_iso: "MM", code_un: "MMR" },
      { name: "Namibia", code_iso: "NA", code_un: "NAM" },
      { name: "Nauru", code_iso: "NR", code_un: "NRU" },
      { name: "Nepal", code_iso: "NP", code_un: "NPL" },
      { name: "Netherlands", code_iso: "NL", code_un: "NLD" },
      { name: "New Caledonia", code_iso: "NC", code_un: "NCL" },
      { name: "New Zealand", code_iso: "NZ", code_un: "NZL" },
      { name: "Nicaragua", code_iso: "NI", code_un: "NIC" },
      { name: "Niger", code_iso: "NE", code_un: "NER" },
      { name: "Nigeria", code_iso: "NG", code_un: "NGA" },
      { name: "Niue", code_iso: "NU", code_un: "NIU" },
      { name: "Norfolk Island", code_iso: "NF", code_un: "NFK" },
      { name: "Northern Mariana Islands", code_iso: "MP", code_un: "MNP" },
      { name: "Norway", code_iso: "NO", code_un: "NOR" },
      { name: "Oman", code_iso: "OM", code_un: "OMN" },
      { name: "Pakistan", code_iso: "PK", code_un: "PAK" },
      { name: "Palau", code_iso: "PW", code_un: "PLW" },
      { name: "Palestine, State of", code_iso: "PS", code_un: "PSE" },
      { name: "Panama", code_iso: "PA", code_un: "PAN" },
      { name: "Papua New Guinea", code_iso: "PG", code_un: "PNG" },
      { name: "Paraguay", code_iso: "PY", code_un: "PRY" },
      { name: "Peru", code_iso: "PE", code_un: "PER" },
      { name: "Philippines", code_iso: "PH", code_un: "PHL" },
      { name: "Pitcairn", code_iso: "PN", code_un: "PCN" },
      { name: "Poland", code_iso: "PL", code_un: "POL" },
      { name: "Portugal", code_iso: "PT", code_un: "PRT" },
      { name: "Puerto Rico", code_iso: "PR", code_un: "PRI" },
      { name: "Qatar", code_iso: "QA", code_un: "QAT" },
      { name: "Romania", code_iso: "RO", code_un: "ROU" },
      { name: "Russian Federation", code_iso: "RU", code_un: "RUS" },
      { name: "Rwanda", code_iso: "RW", code_un: "RWA" },
      { name: "Reunion", code_iso: "RE", code_un: "REU" },
      { name: "Saint Barthalemy", code_iso: "BL", code_un: "BLM" },
      { name: "Saint Helena", code_iso: "SH", code_un: "SHN" },
      { name: "Saint Kitts and Nevis", code_iso: "KN", code_un: "KNA" },
      { name: "Saint Lucia", code_iso: "LC", code_un: "LCA" },
      { name: "Saint Martin (French part)", code_iso: "MF", code_un: "MAF" },
      { name: "Saint Pierre and Miquelon", code_iso: "PM", code_un: "SPM" },
      { name: "Saint Vincent and the Grenadines", code_iso: "VC", code_un: "VCT" },
      { name: "Samoa", code_iso: "WS", code_un: "WSM" },
      { name: "San Marino", code_iso: "SM", code_un: "SMR" },
      { name: "Sao Tome and Principe", code_iso: "ST", code_un: "STP" },
      { name: "Saudi Arabia", code_iso: "SA", code_un: "SAU" },
      { name: "Senegal", code_iso: "SN", code_un: "SEN" },
      { name: "Serbia", code_iso: "RS", code_un: "SRB" },
      { name: "Seychelles", code_iso: "SC", code_un: "SYC" },
      { name: "Sierra Leone", code_iso: "SL", code_un: "SLE" },
      { name: "Singapore", code_iso: "SG", code_un: "SGP" },
      { name: "Sint Maarten (Dutch part)", code_iso: "SX", code_un: "SXM" },
      { name: "Slovakia", code_iso: "SK", code_un: "SVK" },
      { name: "Slovenia", code_iso: "SI", code_un: "SVN" },
      { name: "Solomon Islands", code_iso: "SB", code_un: "SLB" },
      { name: "Somalia", code_iso: "SO", code_un: "SOM" },
      { name: "South Africa", code_iso: "ZA", code_un: "ZAF" },
      { name: "South Georgia and the South Sandwich Islands", code_iso: "GS", code_un: "SGS" },
      { name: "South Sudan", code_iso: "SS", code_un: "SSD" },
      { name: "Spain", code_iso: "ES", code_un: "ESP" },
      { name: "Sri Lanka", code_iso: "LK", code_un: "LKA" },
      { name: "Sudan", code_iso: "SD", code_un: "SDN" },
      { name: "Suriname", code_iso: "SR", code_un: "SUR" },
      { name: "Svalbard and Jan Mayen", code_iso: "SJ", code_un: "SJM" },
      { name: "Swaziland", code_iso: "SZ", code_un: "SWZ" },
      { name: "Sweden", code_iso: "SE", code_un: "SWE" },
      { name: "Switzerland", code_iso: "CH", code_un: "CHE" },
      { name: "Syrian Arab Republic", code_iso: "SY", code_un: "SYR" },
      { name: "Taiwan, Province of China", code_iso: "TW", code_un: "TWN" },
      { name: "Tajikistan", code_iso: "TJ", code_un: "TJK" },
      { name: "United Republic of Tanzania", code_iso: "TZ", code_un: "TZA" },
      { name: "Thailand", code_iso: "TH", code_un: "THA" },
      { name: "Timor-Leste", code_iso: "TL", code_un: "TLS" },
      { name: "Togo", code_iso: "TG", code_un: "TGO" },
      { name: "Tokelau", code_iso: "TK", code_un: "TKL" },
      { name: "Tonga", code_iso: "TO", code_un: "TON" },
      { name: "Trinidad and Tobago", code_iso: "TT", code_un: "TTO" },
      { name: "Tunisia", code_iso: "TN", code_un: "TUN" },
      { name: "Turkey", code_iso: "TR", code_un: "TUR" },
      { name: "Turkmenistan", code_iso: "TM", code_un: "TKM" },
      { name: "Turks and Caicos Islands", code_iso: "TC", code_un: "TCA" },
      { name: "Tuvalu", code_iso: "TV", code_un: "TUV" },
      { name: "Uganda", code_iso: "UG", code_un: "UGA" },
      { name: "Ukraine", code_iso: "UA", code_un: "UKR" },
      { name: "United Arab Emirates", code_iso: "AE", code_un: "ARE" },
      { name: "United Kingdom", code_iso: "GB", code_un: "GBR" },
      { name: "United States", code_iso: "US", code_un: "USA" },
      { name: "United States Minor Outlying Islands", code_iso: "UM", code_un: "UMI" },
      { name: "Uruguay", code_iso: "UY", code_un: "URY" },
      { name: "Uzbekistan", code_iso: "UZ", code_un: "UZB" },
      { name: "Vanuatu", code_iso: "VU", code_un: "VUT" },
      { name: "Venezuela", code_iso: "VE", code_un: "VEN" },
      { name: "Viet Nam", code_iso: "VN", code_un: "VNM" },
      { name: "British Virgin Islands", code_iso: "VG", code_un: "VGB" },
      { name: "US Virgin Islands", code_iso: "VI", code_un: "VIR" },
      { name: "Wallis and Futuna", code_iso: "WF", code_un: "WLF" },
      { name: "Western Sahara", code_iso: "EH", code_un: "ESH" },
      { name: "Yemen", code_iso: "YE", code_un: "YEM" },
      { name: "Zambia", code_iso: "ZM", code_un: "ZMB" },
      { name: "Zimbabwe", code_iso: "ZW", code_un: "ZWE" },
      { name: "Aland Islands", code_iso: "AX", code_un: "ALA" },
      { name: "Europe", code_iso: "EU", code_un: nil },
  ])

end
