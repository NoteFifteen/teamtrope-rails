Rails.application.routes.draw do

  resources :print_corners

  resources :kdp_select_enrollments

  resources :man_devs

  resources :document_import_queues

  resources :approve_blurbs

  resources :draft_blurbs

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  get 'wordpress_import/import'
  post 'wordpress_import/upload'

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

  get '/admin/reports/high_allocations',     to: 'reports#high_allocations'
  get 'admin/reports/missing_current_tasks', to: 'reports#missing_current_tasks'
  match '/admin/wordpress_import/import',    to: 'wordpress_import#import', via: :get
  post '/admin/wordpress_import/upload',     to: 'wordpress_import#upload', via: :post

  get '/box/request_access', to: 'static_pages#box_request_access', as: 'box_request'
  get '/box/redirect',       to: 'static_pages#box_redirect',       as: 'box-redirect'

  #post 'hellosign' => 'hellosign#record_event'

  resources :projects do
    resource :analytics, only: [:show]
  end

  match '/projects/accept_team_member/:id',       to: 'projects#accept_team_member',       via: [:patch, :post]
  match '/projects/add_stock_cover_image/:id',    to: 'projects#add_stock_cover_image',    via: 'patch'
  match '/projects/approve_blurb/:id',            to: 'projects#approve_blurb',            via: 'patch'
  match '/projects/approve_cover_art/:id',        to: 'projects#approve_cover_art',        via: 'patch'
  match '/projects/approve_layout/:id',           to: 'projects#approve_layout',           via: 'patch'
  match '/projects/artwork_rights_request/:id',   to: 'projects#artwork_rights_request',   via: 'patch'
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
  match '/projects/man_dev/:id',                  to: 'projects#man_dev',                  via: 'patch'
  match '/projects/marketing_expense/:id',        to: 'projects#marketing_expense',        via: 'patch'
  match '/projects/marketing_release_date/:id',   to: 'projects#marketing_release_date',   via: 'patch'
  match '/projects/media_kit/:id',                to: 'projects#media_kit',                via: 'patch'
  match '/projects/original_manuscript/:id',      to: 'projects#original_manuscript',      via: 'patch'
  match '/projects/price_promotion/:id',          to: 'projects#price_promotion',          via: 'patch'
  match '/projects/print_corner_request/:id',     to: 'projects#print_corner_request',     via: 'patch'
  match '/projects/proofed_manuscript/:id',       to: 'projects#proofed_manuscript',       via: 'patch'
  match '/projects/publish_book/:id',             to: 'projects#publish_book',             via: 'patch'
  match '/projects/remove_team_member/:id',       to: 'projects#remove_team_member',       via: 'patch'
  match '/projects/revenue_allocation_split/:id', to: 'projects#revenue_allocation_split', via: 'patch'
  match '/projects/request_images/:id',           to: 'projects#request_images',           via: 'patch'
  match '/projects/submit_blurb/:id',             to: 'projects#submit_blurb',             via: 'patch'
  match '/projects/submit_form_1099/:id',         to: 'projects#submit_form_1099',         via: 'patch'
  match '/projects/submit_submit_pfs/:id',        to: 'projects#submit_pfs',               via: 'patch'
  match '/projects/update_final_page_count/:id',  to: 'projects#update_final_page_count',  via: 'patch'
  match '/projects/update_status/:id',            to: 'projects#update_status',            via: 'patch'
  match '/projects/upload_cover_templates/:id',   to: 'projects#upload_cover_templates',   via: 'patch'

  match '/projects/download_original_manuscript/:id',  to: 'projects#download_original_manuscript', via: 'get', as: 'download_original_manuscript'
  match '/projects/download_edited_manuscript/:id',    to: 'projects#download_edited_manuscript',   via: 'get', as: 'download_edited_manuscript'
  match '/projects/download_proofed_manuscript/:id',   to: 'projects#download_proofed_manuscript',  via: 'get', as: 'download_proofed_manuscript'

  match '/projects/download_published_file_mobi/:id',  to: 'projects#download_published_file_mobi', via: 'get', as: 'download_published_file_mobi'
  match '/projects/download_published_file_epub/:id',  to: 'projects#download_published_file_epub', via: 'get', as: 'download_published_file_epub'
  match '/projects/download_published_file_pdf/:id',   to: 'projects#download_published_file_pdf',  via: 'get', as: 'download_published_file_pdf'

  match '/projects/download_media_kit/:id',            to: 'projects#download_media_kit',           via: 'get', as: 'download_media_kit'
  match '/projects/download_layout/:id',               to: 'projects#download_layout',              via: 'get', as: 'download_layout'

  match '/projects/download_final_manuscript_pdf/:id', to: 'projects#download_final_manuscript_pdf', via: 'get', as: 'download_final_manuscript_pdf'
  match '/projects/download_final_manuscript_doc/:id', to: 'projects#download_final_manuscript_doc', via: 'get', as: 'download_final_manuscript_doc'

  match '/projects/download_alternate_cover/:id',        to: 'projects#download_alternate_cover',        via: 'get', as: 'download_alternate_cover'
  match '/projects/download_createspace_cover/:id',      to: 'projects#download_createspace_cover',      via: 'get', as: 'download_createspace_cover'
  match '/projects/download_ebook_front_cover/:id',      to: 'projects#download_ebook_front_cover',      via: 'get', as: 'download_ebook_front_cover'
  match '/projects/download_lightning_source_cover/:id', to: 'projects#download_lightning_source_cover', via: 'get', as: 'download_lightning_source_cover'

  match '/projects/download_cover_concept/:id',          to: 'projects#download_cover_concept',          via: 'get', as: 'download_cover_concept'
  match '/projects/download_stock_cover_image/:id',      to: 'projects#download_stock_cover_image',      via: 'get', as: 'download_stock_cover_image'

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
  resources :published_files


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
