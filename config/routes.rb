Rails.application.routes.draw do


  match 'hellosign_documents/cancel_request/:id', to: 'hellosign_documents#cancel_signature_request', via: :patch

  resources :hellosign_document_types
  mount Resque::Server, at: "/resque"

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  get 'wordpress_import/import'
  post 'wordpress_import/upload'

  match '/parse/get_amazon_sales_rank',            to: 'parse#get_amazon_sales_rank',          via: 'get'
  match '/parse/get_queued_items',                 to: 'parse#get_queued_items',               via: 'get'
  match '/parse/add_book_to_price_change_queue',   to: 'parse#add_book_to_price_change_queue', via: 'get'
  match '/parse/get_sales_data_for_channel',       to: 'parse#get_sales_data_for_channel',     via: 'get'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home'

  get '/admin/reports/high_allocations',         to: 'reports#high_allocations'
  get 'admin/reports/missing_current_tasks',     to: 'reports#missing_current_tasks'

  get 'admin/reports/scribd_export',             to: 'reports#scribd_metadata_export'
  post 'admin/reports/send_scribd_export_email', to: 'reports#send_scribd_export_email', via: :post

  match '/admin/wordpress_import/import',        to: 'wordpress_import#import', via: :get
  post '/admin/wordpress_import/upload',         to: 'wordpress_import#upload', via: :post

  get '/box/request_access', to: 'static_pages#box_request_access', as: 'box_request'
  get '/box/redirect',       to: 'static_pages#box_redirect',       as: 'box-redirect'

  post 'hellosign' => 'hellosign#record_event'

  resources :projects do
    resource :analytics, only: [:show]
    resource :cover_concepts
    resource :cover_template
    resource :final_manuscript
    resource :manuscript
    resource :media_kit
    resource :project_layout
    resource :published_file
  end

  get '/projects_grid_view', to: 'projects#grid_view'

  match '/projects/accept_team_member/:id',       to: 'projects#accept_team_member',       via: [:patch, :post]
  match '/projects/add_stock_cover_image/:id',    to: 'projects#add_stock_cover_image',    via: 'patch'
  match '/projects/approve_blurb/:id',            to: 'projects#approve_blurb',            via: 'patch'
  match '/projects/approve_cover_art/:id',        to: 'projects#approve_cover_art',        via: 'patch'
  match '/projects/approve_final_cover/:id',      to: 'projects#approve_final_cover',      via: 'patch'
  match '/projects/approve_layout/:id',           to: 'projects#approve_layout',           via: 'patch'
  match '/projects/artwork_rights_request/:id',   to: 'projects#artwork_rights_request',   via: 'patch'
  match '/projects/blog_tour/:id',                to: 'projects#blog_tour',                via: 'patch'
  match '/projects/bookbub_submission/:id',       to: 'projects#bookbub_submission',       via: 'patch'
  match '/projects/check_imprint/:id',            to: 'projects#check_imprint',            via: 'patch'
  match '/projects/cover_concept_upload/:id',     to: 'projects#cover_concept_upload',     via: 'patch'
  # Post is defined for this path since creates and updates are used interchangeably.
  match '/projects/edit_control_numbers/:id',     to: 'projects#edit_control_numbers',     via: [:patch, :post]
  match '/projects/edit_complete_date/:id',       to: 'projects#edit_complete_date',       via: 'patch'
  match '/projects/edit_layout_style/:id',        to: 'projects#edit_layout_style',        via: 'patch'
  match '/projects/edited_manuscript/:id',        to: 'projects#edited_manuscript',        via: 'patch'
  match '/projects/final_manuscript/:id',         to: 'projects#final_manuscript',         via: 'patch'
  match '/projects/kdp_select/:id',               to: 'projects#kdp_select',               via: 'patch'
  match '/projects/kdp_update/:id',               to: 'projects#kdp_update',               via: 'patch'
  match '/projects/layout_upload/:id',            to: 'projects#layout_upload',            via: 'patch'
  match '/projects/man_dev/:id',                  to: 'projects#man_dev',                  via: 'patch'
  match '/projects/marketing_expense/:id',        to: 'projects#marketing_expense',        via: 'patch'
  match '/projects/media_kit/:id',                to: 'projects#media_kit',                via: 'patch'
  match '/projects/ebook_only_incentive/:id',     to: 'projects#ebook_only_incentive',     via: 'patch'
  match '/projects/netgalley_submission/:id',     to: 'projects#new_netgalley_submission', via: 'patch'
  match '/projects/original_manuscript/:id',      to: 'projects#original_manuscript',      via: 'patch'
  match '/projects/production_expense/:id',       to: 'projects#production_expense',       via: 'patch'
  match '/projects/price_promotion/:id',          to: 'projects#price_promotion',          via: 'patch'
  match '/projects/print_corner_request/:id',     to: 'projects#print_corner_request',     via: 'patch'
  match '/projects/print_corner_estore_request/:id',     to: 'projects#print_corner_estore_request',     via: 'patch'
  match '/projects/proofread_final_manuscript/:id',      to: 'projects#proofread_final_manuscript',      via: 'patch'
  match '/projects/proofread_reviewed_manuscript/:id',   to: 'projects#proofread_reviewed_manuscript',   via: 'patch'
  match '/projects/publish_book/:id',             to: 'projects#publish_book',             via: 'patch'
  match '/projects/remove_team_member/:id',       to: 'projects#remove_team_member',       via: 'patch'
  match '/projects/revenue_allocation_split/:id', to: 'projects#revenue_allocation_split', via: 'patch'
  match '/projects/request_images/:id',           to: 'projects#request_images',           via: 'patch'
  match '/projects/rights_back_request/:id',      to: 'projects#rights_back_request',      via: 'patch'
  match '/projects/rollback_current_task/:id',    to: 'projects#rollback_current_task',    via: 'patch'
  # Post is defined for this path since creates and updates are used interchangeably.
  match '/projects/social_media_marketing/:id',   to: 'projects#update_social_media_mkt',  via: [:patch, :post]
  match '/projects/submit_blurb/:id',             to: 'projects#submit_blurb',             via: 'patch'
  match '/projects/submit_form_1099/:id',         to: 'projects#submit_form_1099',         via: 'patch'
  match '/projects/submit_submit_pfs/:id',        to: 'projects#submit_pfs',               via: 'patch'
  match '/projects/update_final_page_count/:id',  to: 'projects#update_final_page_count',  via: 'patch'
  match '/projects/update_genre/:id',             to: 'projects#update_genre',             via: 'patch'
  match '/projects/upload_cover_templates/:id',   to: 'projects#upload_cover_templates',   via: 'patch'

  match '/projects/download_original_manuscript/:id',           to: 'projects#download_original_manuscript',           via: 'get', as: 'download_original_manuscript'
  match '/projects/download_edited_manuscript/:id',             to: 'projects#download_edited_manuscript',             via: 'get', as: 'download_edited_manuscript'
  match '/projects/download_proofread_reviewed_manuscript/:id', to: 'projects#download_proofread_reviewed_manuscript', via: 'get', as: 'download_proofread_reviewed_manuscript'
  match '/projects/download_proofread_final_manuscript/:id',    to: 'projects#download_proofread_final_manuscript',    via: 'get', as: 'download_proofread_final_manuscript'

  match '/projects/download_published_file_mobi/:id',  to: 'projects#download_published_file_mobi', via: 'get', as: 'download_published_file_mobi'
  match '/projects/download_published_file_epub/:id',  to: 'projects#download_published_file_epub', via: 'get', as: 'download_published_file_epub'
  match '/projects/download_published_file_pdf/:id',   to: 'projects#download_published_file_pdf',  via: 'get', as: 'download_published_file_pdf'

  match '/projects/download_media_kit/:id',            to: 'projects#download_media_kit',           via: 'get', as: 'download_media_kit'
  match '/projects/download_layout/:id',               to: 'projects#download_layout',              via: 'get', as: 'download_layout'

  match '/projects/download_final_manuscript_pdf/:id', to: 'projects#download_final_manuscript_pdf', via: 'get', as: 'download_final_manuscript_pdf'
  match '/projects/download_final_manuscript_doc/:id', to: 'projects#download_final_manuscript_doc', via: 'get', as: 'download_final_manuscript_doc'

  match '/projects/download_raw_cover/:id',                  to: 'projects#download_raw_cover',                 via: 'get', as: 'download_raw_cover'
  match '/projects/download_alternate_cover/:id',            to: 'projects#download_alternate_cover',           via: 'get', as: 'download_alternate_cover'
  match '/projects/download_createspace_cover/:id',          to: 'projects#download_createspace_cover',         via: 'get', as: 'download_createspace_cover'
  match '/projects/download_ebook_front_cover/:id',          to: 'projects#download_ebook_front_cover',         via: 'get', as: 'download_ebook_front_cover'
  match '/projects/download_lightning_source_cover/:id',     to: 'projects#download_lightning_source_cover',    via: 'get', as: 'download_lightning_source_cover'
  match '/projects/download_font_license/:id',               to: 'projects#download_font_license',              via: 'get', as: 'download_font_license'
  match '/projects/download_final_cover_screenshot/:id',  to: 'projects#download_final_cover_screenshot', via: 'get', as: 'download_final_cover_screenshot'

  match '/projects/download_cover_concept/:id',              to: 'projects#download_cover_concept',             via: 'get', as: 'download_cover_concept'
  match '/projects/download_unapproved_cover_concept/:id',   to: 'projects#download_unapproved_cover_concept',  via: 'get', as: 'download_unapproved_cover_concept'
  match '/projects/download_stock_cover_image/:id',          to: 'projects#download_stock_cover_image',         via: 'get', as: 'download_stock_cover_image'

  match 'visitors', to: 'static_pages#visitors', via: 'get'

  match 'kdp-select-exception-report', to: 'channel_reports#most_resent_report', via: 'get'

  resources :approve_blurbs
  resources :artwork_rights_requests
  resources :audit_team_membership_removals
  resources :blog_tours
  resources :bookbub_submissions
  resources :channel_report_items
  resources :channel_reports
  resources :control_numbers
  resources :cover_concepts
  resources :cover_templates
  resources :current_tasks
  resources :document_import_queues
  resources :draft_blurbs
  resources :ebook_only_incentives
  resources :final_manuscripts
  resources :genres
  resources :hellosign_documents
  resources :imprints
  resources :kdp_select_enrollments
  resources :man_devs
  resources :manuscripts
  resources :marketing_expenses
  resources :media_kits
  resources :netgalley_submissions
  resources :phases
  resources :publication_fact_sheets
  resources :published_files
  resources :price_change_promotions
  resources :print_corners
  resources :production_expenses
  resources :project_type_workflows
  resources :project_types
  resources :project_views
  resources :required_roles
  resources :rights_back_requests
  resources :roles
  resources :social_media_marketings
  resources :tabs
  resources :tasks
  resources :task_dependencies
  resources :task_performers
  resources :task_prerequisite_fields
  resources :unlocked_tasks
  resources :workflows


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
