Rails.application.routes.draw do
  get 'store/index'
  get 'store/sort' 
  get 'contact', to: 'navigation#contact'

  resources :products
  resources :sale_products
  resources :line_items, only: [:create, :destroy]
  resources :carts, only: [:show, :destroy]
 
  devise_for :buyers, controllers: { registrations: "buyers/registrations", sessions: "buyers/sessions", passwords: "buyers/passwords" }
  devise_scope :buyer do
    get 'buyers/show', to: "buyers/sessions#show", as: 'buyer'
    match 'buyer', to: 'buyers/sessions#show', via: 'get'
  end
  devise_for :sellers, controllers: { registrations: "sellers/registrations", sessions: "sellers/sessions", passwords: "sellers/passwords" }
  resources :orders

  root to: 'store#index' , as: 'store'

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
  #     #   end
end
