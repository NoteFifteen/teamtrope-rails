Rails.application.routes.draw do

  
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
  
  resources :projects
  
  match '/projects/edit_complete_date/:id',   to: 'projects#edit_complete_date',  via: 'patch'
  match '/projects/original_manuscript/:id',  to: 'projects#original_manuscript', via: 'patch'
  match '/projects/edited_manuscript/:id',    to: 'projects#edited_manuscript',   via: 'patch'

  # Post is defined for this path since creates and updates are used interchangeably.
  match '/projects/edit_control_numbers/:id', to: 'projects#edit_control_numbers',   via: 'post'

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
  resources :current_tasks
  resources :unlocked_tasks
  resources :genres
  resources :phases
  resources :required_roles
  resources :project_type_workflows
  resources :project_types
  resources :workflows
  resources :tasks   
   
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
