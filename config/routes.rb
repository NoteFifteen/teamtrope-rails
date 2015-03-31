Rails.application.routes.draw do


  resources :marketing_expenses

  resources :publication_fact_sheets

  match '/parse/get_amazon_sales_rank',            to: 'parse#get_amazon_sales_rank',          via: 'get'
  match '/parse/get_queued_items',                 to: 'parse#get_queued_items',               via: 'get'
  match '/parse/add_book_to_price_change_queue',   to: 'parse#add_book_to_price_change_queue', via: 'get'
  match '/parse/get_sales_data_for_channel',       to: 'parse#get_sales_data_for_channel',     via: 'get'
  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'static_pages#home'

  resources :sessions, only: [:new, :create, :destroy]
  resources :users do
  	member do
  		get 'activity'
  	end
  	resources :profiles, shallow: true, only: [:edit,:update]
  end
  
  get '/users/:id/activity/mentions',  to: 'users#mentions',  as: 'mentions'
  get '/users/:id/activity/favorites', to: 'users#favorites', as: 'favorites'
  get '/users/:id/activity/groups',    to: 'users#groups',    as: 'groups'
  
  get '/box/request_access', to: 'static_pages#box_request_access', as: 'box_request'
  get '/box/redirect',       to: 'static_pages#box_redirect',       as: 'box-redirect'
  
  resources :projects

  match '/projects/accept_team_member/:id',       to: 'projects#accept_team_member',       via: [:patch, :post]
  match '/projects/add_stock_cover_image/:id',    to: 'projects#add_stock_cover_image',    via: 'patch'
  match '/projects/approve_cover_art/:id',        to: 'projects#approve_cover_art',        via: 'patch'
  match '/projects/approve_layout/:id',           to: 'projects#approve_layout',           via: 'patch'
  match '/projects/blog_tour/:id',                to: 'projects#blog_tour',                via: 'patch'
  match '/projects/cover_concept_upload/:id',     to: 'projects#cover_concept_upload',     via: 'patch'
  # Post is defined for this path since creates and updates are used interchangeably.
  match '/projects/edit_control_numbers/:id',     to: 'projects#edit_control_numbers',     via: 'post'
  match '/projects/edit_complete_date/:id',       to: 'projects#edit_complete_date',       via: 'patch'
  match '/projects/edit_layout_style/:id',        to: 'projects#edit_layout_style',        via: 'patch'
  match '/projects/edited_manuscript/:id',        to: 'projects#edited_manuscript',        via: 'patch'
  match '/projects/final_manuscript/:id',         to: 'projects#final_manuscript',         via: 'patch'
  match '/projects/kdp_select/:id',               to: 'projects#kdp_select',               via: 'patch'
  match '/projects/kdp_update/:id',               to: 'projects#kdp_update',               via: 'patch'
  match '/projects/layout_upload/:id',            to: 'projects#layout_upload',            via: 'patch'
  match '/projects/marketing_expense/:id',        to: 'projects#marketing_expense',        via: 'patch'
  match '/projects/marketing_release_date/:id',   to: 'projects#marketing_release_date',   via: 'patch'
  match '/projects/media_kit/:id',                to: 'projects#media_kit',                via: 'patch'
  match '/projects/original_manuscript/:id',      to: 'projects#original_manuscript',      via: 'patch'
  match '/projects/price_promotion/:id',          to: 'projects#price_promotion',          via: 'patch'
  match '/projects/proofed_manuscript/:id',       to: 'projects#proofed_manuscript',       via: 'patch'
  match '/projects/publish_book/:id',             to: 'projects#publish_book',             via: 'patch'
  match '/projects/remove_team_member/:id',       to: 'projects#remove_team_member',       via: 'patch'
  match '/projects/revenue_allocation_split/:id', to: 'projects#revenue_allocation_split', via: 'patch'
  match '/projects/request_images/:id',           to: 'projects#request_images',           via: 'patch'
  match '/projects/submit_form_1099/:id',         to: 'projects#submit_form_1099',         via: 'patch'
  match '/projects/submit_submit_pfs/:id',        to: 'projects#submit_pfs',               via: 'patch'
  match '/projects/update_final_page_count/:id',  to: 'projects#update_final_page_count',  via: 'patch'
  match '/projects/update_status/:id',            to: 'projects#update_status',            via: 'patch'
  match '/projects/upload_cover_templates/:id',   to: 'projects#upload_cover_templates',   via: 'patch'

  resources :posts do
  	resources :comments, shallow: true
  end
  
  resources :tags, except: :index
  resources :statuses
  
  match 'signup',  to: 'users#new',        via: 'get'
  match 'signin',  to: 'sessions#new',     via: 'get'
  match 'signout', to: 'sessions#destroy', via: 'get'
  match 'visitors', to: 'static_pages#visitors', via: 'get'
  
  resources :tabs
  resources :project_views
  resources :roles
  resources :task_prerequisite_fields
  resources :blog_tours
  resources :current_tasks
  resources :unlocked_tasks
  resources :genres
  resources :phases
  resources :required_roles
  resources :project_type_workflows
  resources :project_types
  resources :workflows
  resources :tasks
  resources :imprints
  resources :status_updates
  resources :price_change_promotions  
  
   
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
