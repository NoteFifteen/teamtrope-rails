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
  {name: "Edge"}
])

# create the roles
Role.create!([
  {name: "Author", contract_description: 'The author role contract text'},
  {name: "Book Manager", contract_description: 'The Book Manager role contract text'},
  {name: "Cover Designer", contract_description: 'The Cover Designer role contract text'},
  {name: "Editor", contract_description: 'The Editor role contract text'},
  {name: "Project Manager", contract_description: 'The Projct Manager role contract text'},
  {name: "Proofreader", contract_description: 'The Proofreader role contract text'},
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
  { project_type: {name: "Standard Project", team_total_percent: 70.0}, workflows: [:production, :marketing, :design], required_roles: { "Author" => { suggested_percent: 33.0 }, "Book Manager" => { suggested_percent: 20.0 }, "Cover Designer" => { suggested_percent: 4.0 }, "Editor" => { suggested_percent: 7.0 }, "Project Manager" => { suggested_percent: 4.0 }, "Proofreader" => { suggested_percent: 2.0 } } }
]

# creating project types
project_types.each do | pt |

  project_type = ProjectType.create!(pt[:project_type])
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

  :manuscript_development =>        { task: { workflow_id: :production,  next_id: :original_manuscript, rejected_task_id: nil,   partial: "manuscript_development",   name: "Manuscript Development",    icon: "icon-bookmark",    tab_text: "",                          intro_video: "" ,  days_to_complete: nil }, root: true, unlocked: ["1099 Form", "Accept Member", "Assets", "Edit Complete Date", "Market Release Date", "Project Details", "Revenue Split", "Team Change", "Update", "Artwork Rights Request", "Team"], performers: ["Author"]},
  :original_manuscript =>           { task: { workflow_id: :production,  next_id: :edited_manuscript,   rejected_task_id: nil,   partial: "original_manuscript",      name: "Original Manuscript",       icon: "icon-bookmark",    tab_text: "Orig. Man.",                intro_video: "" ,  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Edit Complete Date", "Market Release Date", "Project Details", "Revenue Split", "Team Change", "Update", "Artwork Rights Request", "Team"], performers: ["Author"]},
  :edited_manuscript =>             { task: { workflow_id: :production,  next_id: :submit_proofread,    rejected_task_id: nil,   partial: "edited_manuscript",        name: "Edited Manuscript",         icon: "icon-edit",        tab_text: "Edited Manuscript",         intro_video: "" ,   days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Edit Complete Date", "Project Details", "Revenue Split", "Team Change", "Submit Edited", "Update", "Artwork Rights Request", "Team"], performers: ['Author', 'Editor', 'Project Manager']},
  :submit_proofread =>              { task: { workflow_id: :production,  next_id: :choose_style,        rejected_task_id: nil,   partial: "submit_proofread",         name: "Proofread Complete",        icon: "icon-ok-sign",     tab_text: "Proofread Complete",        intro_video: "" ,  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Project Details", "Revenue Split", "Team Change", "Update", "Team", "Control Numbers", "Artwork Rights Request", "Market Release Date"], performers: ['Author']},
  :choose_style =>                  { task: { workflow_id: :production,  next_id: :upload_layout,       rejected_task_id: nil,   partial: "choose_style",             name: "Choose Style",              icon: "icon-adjust",      tab_text: "Choose Style",              intro_video: "" ,  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Project Details", "Revenue Split", "Team Change", "Control Numbers", "Update", "Team", "Artwork Rights Request", "Market Release Date"], performers: ['Author', 'Project Manager']},
  :upload_layout =>                 { task: { workflow_id: :production,  next_id: :approve_layout,      rejected_task_id: nil,   partial: "upload_layout",            name: "Upload Layout",             icon: "icon-cloud-upload",tab_text: "Upload Layout",             intro_video: "" ,  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Project Details", "Revenue Split", "Team Change", "Upload Layout", "Team", "Market Release Date", "Artwork Rights Request", "Update"], performers: []},
  :approve_layout =>                { task: { workflow_id: :production,  next_id: :page_count,          rejected_task_id: nil,   partial: "approve_layout",           name: "Approve Layout",            icon: "icon-thumbs-up",   tab_text: "Approve Layout",            intro_video: "" ,  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Project Details", "Market Release Date", "Team", "Revenue Split", "Team Change", "Update", "Artwork Rights Request", "Approve Layout"], performers: ['Author']},
  :page_count =>                    { task: { workflow_id: :production,  next_id: :final_manuscript,    rejected_task_id: nil,   partial: "page_count",               name: "Page Count",                icon: "icon-list-ol",     tab_text: "Page Count",                intro_video: "" ,  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Final Page Count", "Project Details", "Revenue Split", "Team Change", "Team", "Market Release Date", "Artwork Rights Request", "Update"], performers: []},
  :final_manuscript =>              { task: { workflow_id: :production,  next_id: :publish_book,        rejected_task_id: nil,   partial: "final_manuscript",         name: "Final Manuscript",          icon: "icon-bookmark",    tab_text: "Final Manuscript",          intro_video: "" ,  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Final Manuscript", "Project Details", "Revenue Split", "Team Change", "Team", "Market Release Date", "Artwork Rights Request", "Update"], performers: []},
  :publish_book =>                  { task: { workflow_id: :production,  next_id: :production_complete, rejected_task_id: nil,   partial: "publish_book",             name: "Publish Book",              icon: "icon-star",        tab_text: "Publish Book",              intro_video: "" ,  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Project Details", "Publish Book", "Revenue Split", "Team Change", "Team", "Market Release Date", "Update", "Production Expense", "Artwork Rights Request", "Control Numbers"], performers: []},
  :production_complete =>           { task: { workflow_id: :production,  next_id: nil,                  rejected_task_id: nil,   partial: nil,                        name: "Production Complete",       icon: "",                 tab_text: "",                          intro_video: "" ,  days_to_complete: nil }, unlocked: ["1099 Form", "Accept Member", "Assets", "Blog Tour", "Media Kit", "Project Details", "Promos", "Revenue Split", "Team Change", "Print Corner", "Control Numbers", "Analytics", "Artwork Rights Request", "Team", "Update", "Marketing Expense", "KDP Select Enrollment", "KDP Select Update"]},

  :upload_cover_concept =>          { task: { workflow_id: :design,      next_id: :approve_cover_art,      rejected_task_id: nil,                   partial: "upload_cover_concept",     name: "Cover Concept",             icon: "icon-bookmark",    tab_text: "Cover Concept",          intro_video: "" ,  days_to_complete: nil }, root: true, unlocked: ["Request Image", "Add Image"], performers: ['Cover Designer', 'Project Manager']},
  :approve_cover_art =>             { task: { workflow_id: :design,      next_id: :upload_cover_templates, rejected_task_id: :upload_cover_concept, partial: "approve_cover_art",        name: "Approve Cover Art",         icon: "icon-thumbs-up",   tab_text: "Approve Cover Art",      intro_video: "" ,  days_to_complete: nil }, unlocked: ["Request Image", "Add Image"], performers: []},
  :upload_cover_templates =>        { task: { workflow_id: :design,      next_id: :design_complete,        rejected_task_id: nil,                   partial: "upload_cover_templates",   name: "Final Covers",              icon: "icon-cloud-upload",tab_text: "Final Covers",           intro_video: "" ,  days_to_complete: nil }, unlocked: ["Request Image", "Add Image"], performers: ['Author', 'Cover Designer', 'Project Manager']},
  :design_complete =>               { task: { workflow_id: :design,      next_id: nil,                     rejected_task_id: nil,                   partial: nil,                        name: "Design Complete",           icon: "",                 tab_text: "",                       intro_video: "" ,  days_to_complete: nil }, unlocked: []},

  :submit_blurb => 									{ task: { workflow_id: :marketing,   next_id: :approve_blurb,                 rejected_task_id: nil,   partial: "submit_blurb", name: "Submit Blurb",       icon: "icon-bookmark",    tab_text: "Submit Blurb",          intro_video: "" ,  days_to_complete: nil }, root: true, unlocked: [], performers: ['Author', 'Book Manager', 'Project Manager']},
  :approve_blurb =>           		  { task: { workflow_id: :marketing,   next_id: :submit_publication_fact_sheet, rejected_task_id: nil,   partial: "approve_blurb",                             name: "Approve Blurb",      icon: "icon-thumbs-up",   tab_text: "Approve Blurb",         intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager', 'Project Manager']},
  :submit_publication_fact_sheet => { task: { workflow_id: :marketing,   next_id: :marketing_complete,            rejected_task_id: nil,   partial: "submit_publication_fact_sheet", name: "Submit PFS",                icon: "icon-bookmark",    tab_text: "Fact Sheet",            intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager', 'Project Manager']},
  :marketing_complete =>            { task: { workflow_id: :marketing,   next_id: nil,                            rejected_task_id: nil,   partial: nil,                             name: "Marketing Complete", icon: "",                 tab_text: "",                      intro_video: "" ,  days_to_complete: nil }, unlocked: []},

  :accept_member =>                 { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "accept_member",            name: "Accept Member",             icon: "icon-thumbs-up",   tab_text: "Accept Member",             intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author']},
  :form_1099 =>                     { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "form_1099",                name: "1099 Form",                 icon: "icon-cogs",        tab_text: "1099 Form",                 intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['*']},
  :revenue_split =>                 { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "revenue_split",            name: "Revenue Split",             icon: "icon-money",       tab_text: "Revenue Split",             intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author']},

	:project_details =>               { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "project_details",          name: "Project Details",           icon: "icon-file-alt",    tab_text: "Details & Synopsis",        intro_video: "" ,  days_to_complete: nil, team_only: false }, unlocked: []},
	:assets =>                        { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "assets",                   name: "Assets",                    icon: "icon-folder-open", tab_text: "Assets & Files",            intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['*']},
	:team =>                          { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "team",                     name: "Team",                      icon: "icon-group",       tab_text: "Team",                      intro_video: "" ,  days_to_complete: nil, team_only: false }, unlocked: []},
	:analytics =>                     { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "analytics",                name: "Analytics",                 icon: "icon-bar-chart",   tab_text: "Analytics",                 intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['*']},
	:update =>                        { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "update",                   name: "Update",                    icon: "icon-lightbulb",   tab_text: "Update",                    intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager', 'Project Manager']},
	:control_numbers =>               { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "control_numbers",          name: "Control Numbers",           icon: "icon-cogs",        tab_text: "Ctrl No.",                  intro_video: "" ,  days_to_complete: nil }, unlocked: []},

  :request_image =>                 { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "request_image",            name: "Request Image",             icon: "icon-adjust",      tab_text: "Request Image",             intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Cover Designer', 'Project Manager']},
  :add_image =>                     { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "add_image",                name: "Add Image",                 icon: "icon-adjust",      tab_text: "Add Image",                 intro_video: "" ,  days_to_complete: nil }, unlocked: []},

  :artwork_rights =>		            { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "artwork_rights",          name: "Artwork Rights Request",     icon: "fa-meh-o",         tab_text: "Artwork Rights Request",    intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Book Manager', 'Project Manager']},
  :market_release_date =>           { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "market_release_date",     name: "Market Release Date",        icon: "icon-calendar",    tab_text: "Mkt Rel",                   intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Book Manager', 'Project Manager']},
  :media_kit =>                     { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "media_kit",               name: "Media Kit",                  icon: "icon-comment",     tab_text: "Media Kit",                 intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Book Manager']},
  :print_corner =>                  { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "print_corner",            name: "Print",                      icon: "icon-envelope",    tab_text: "Print",                     intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager']},
  :blog_tour =>                     { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "blog_tour",               name: "Blog Tour",                  icon: "icon-money",       tab_text: "Blog Tour",                 intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager']},
  :price_promotion =>               { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "price_promotion",         name: "Promos",                     icon: "icon-money",       tab_text: "Promos",                    intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager']},
  :kdp_select_enrollment =>         { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "kdp_select_enrollment",   name: "KDP Select",                 icon: "icon-bookmark",    tab_text: "KDP Select",                intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager']},
  :kdp_select_update =>             { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "kdp_select_update",       name: "KDP Update",                 icon: "icon-bookmark",    tab_text: "KDP Update",                intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author', 'Book Manager']},
  :marketing_expense =>             { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "marketing_expense",       name: "Marketing Expense",          icon: "icon-money",       tab_text: "Mkt $",                     intro_video: "" ,  days_to_complete: nil }, unlocked: []},
  :production_expense =>            { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "production_expense",      name: "Production Expense",         icon: "icon-money",       tab_text: "Prod $",                    intro_video: "" ,  days_to_complete: nil }, unlocked: []},

  :team_change =>                   { task: { workflow_id: nil,          next_id: nil,   rejected_task_id: nil,   partial: "team_change",             name: "Team Change",                icon: "icon-bookmark",    tab_text: "Team Change",               intro_video: "" ,  days_to_complete: nil }, unlocked: [], performers: ['Author']},
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
  { phase: { project_view_id: 1, name: "Overview", color: "white", color_value: "#eee", icon: "icon-dashboard", order: 0},            tabs: [ {task_id: :project_details,        order: 1}, {task_id: :assets,             order: 2}, {task_id: :team,              order: 3}, {task_id: :analytics,          order: 4},{task_id: :update, order: 5}, {task_id: :control_numbers, order: 6}]},
  { phase: { project_view_id: 1, name: "Build Team", color: "yellow", color_value: "#F0D818", icon: "icon-wrench", order: 1},         tabs: [ {task_id: :accept_member,          order: 1}, {task_id: :form_1099,          order: 2}, {task_id: :revenue_split,     order: 3}, {task_id: :team_change,        order: 4}]},
  { phase: { project_view_id: 1, name: "Edit Content", color: "red", color_value: "#E6583E", icon: "icon-pencil", order: 2},          tabs: [ {task_id: :original_manuscript,    order: 1}, {task_id: :edited_manuscript, order: 2}, {task_id: :submit_proofread,   order: 3}]},
  { phase: { project_view_id: 1, name: "Marketing Prep", color: "green", color_value: "#AED991", icon: "icon-bullhorn", order: 3},    tabs: [ {task_id: :submit_blurb,           order: 1}, {task_id: :approve_blurb,      order: 2}, {task_id: :market_release_date,    order: 3}, {task_id: :submit_publication_fact_sheet, order: 4}]},
  { phase: { project_view_id: 1, name: "Design Layout", color: "medblue", color_value: "#0078c0", icon: "icon-screenshot", order: 4}, tabs: [ {task_id: :choose_style,           order: 1}, {task_id: :upload_layout,      order: 2}, {task_id: :approve_layout,    order: 3}, {task_id: :page_count,         order: 4}]},
  { phase: { project_view_id: 1, name: "Design Cover", color: "blue", color_value: "#1394BB", icon: "icon-screenshot", order: 5},     tabs: [ {task_id: :upload_cover_concept,   order: 1}, {task_id: :approve_cover_art,  order: 2}, {task_id: :request_image,     order: 3}, {task_id: :add_image,          order: 4}, {task_id: :upload_cover_templates, order: 5}, {task_id: :artwork_rights, order: 6}]},
  { phase: { project_view_id: 1, name: "Publish", color: "brown", color_value: "#8B7A6A", icon: "icon-book", order: 6},               tabs: [ {task_id: :final_manuscript,       order: 1}, {task_id: :publish_book,       order: 2}]},
  { phase: { project_view_id: 1, name: "Marketing", color: "green", color_value: "#AED991", icon: "icon-bullhorn", order: 7},         tabs: [ {task_id: :media_kit,              order: 1}, {task_id: :print_corner,       order: 2}, {task_id: :blog_tour,         order: 3}, {task_id: :price_promotion,    order: 4}]},
  { phase: { project_view_id: 1, name: "Promotions", color: "green", color_value: "#AED991", icon: "icon-bullhorn", order: 8},        tabs: [ {task_id: :kdp_select_enrollment,  order: 1}, {task_id: :kdp_select_update,  order: 2}, {task_id: :marketing_expense, order: 3}, {task_id: :production_expense, order: 4}]}
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
    {stock_image_request_link: "", previously_published: nil, prev_publisher_and_date: "", proofed_word_count: nil, teamroom_link: "", publication_date: nil, marketing_release_date: nil, title: "Between Boyfriends by Sárka-Jonae Miller", final_title: "Between Boyfriends", special_text_treatment: "", has_sub_chapters: nil, has_index: nil, non_standard_size: nil, has_internal_illustrations: nil, color_interior: nil, childrens_book: nil, edit_complete_date: nil, project_type_id: 1},
    {stock_image_request_link: "", previously_published: nil, prev_publisher_and_date: "", proofed_word_count: nil, teamroom_link: "", publication_date: nil, marketing_release_date: nil, title: "Atolovus by David Covenant",               final_title: "Atolovus",           special_text_treatment: "", has_sub_chapters: nil, has_index: nil, non_standard_size: nil, has_internal_illustrations: nil, color_interior: nil, childrens_book: nil, edit_complete_date: nil, project_type_id: 1}
  ])

  Project.all.each do | project |
    project.project_type.workflows.each do | workflow |
      ct = project.current_tasks.create(task_id: workflow.root.id)
    end
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
  end
end
