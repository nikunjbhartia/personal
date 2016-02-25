Rails.application.routes.draw do
  scope :authenticate do
    devise_for :users
  end

  resources :users
  resources :revised_two_level_categories
  resources :three_level_categories
  resources :master_category_mappings
  resources :product_three_level_categories
  resources :categories

  unless Rails.application.config.consider_all_requests_local
    get '*not_found', to: 'errors#error_404'
  end

  get "/delete-migrations-ask" => "categories#delete_migrations_ask"
  get "/delete-migrations" => "categories#delete_migrations" 
  
  get "/validate" => 'validation#new'
  post "/validate_categories"  => 'validation#validate_categories'
  get "/migrate" => 'migration#new'
  get "/migrate_categories" => 'migration#migrate_categories'

  get "/migration/delete" => 'migration#delete'

  get "/manage" => 'migration#manage'
  root to: 'users#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
