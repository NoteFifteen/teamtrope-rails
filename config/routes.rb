Rails.application.routes.draw do

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
  resources :posts do
  	resources :comments, shallow: true
  end
  
  resources :tags, except: :index
  resources :process_control_records
  resources :statuses
  
  match 'signup',  to: 'users#new',        via: 'get'
  match 'signin',  to: 'sessions#new',     via: 'get'
  match 'signout', to: 'sessions#destroy', via: 'get'
  match 'visitors', to: 'static_pages#visitors', via: 'get'
   
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
