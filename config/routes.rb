DotaMarket::Application.routes.draw do
  get "search/new"

  get "search/create"

  get "search/show"

  resources :contact_messages, only: [:new, :create]

  resources :users do
    resources :user_listings 
  end

  resources :user_listings do
    resources :comments, only: [:create, :destroy]
  end

   resources :users do
     resources :messages do
        get "sent_messages", :on => :collection
        member do 
          get 'marked_as_read'
        end
        get "conversation", :on => :collection
      end
  end

  resources :users do
    resources :comments, only: [:create, :destroy]
  end

  resources :users do
    resources :relationships, only: [:new, :create, :edit, :destroy]
  end

  resources :items
  resources :sessions, only: [:create, :destroy]

  # SESSIONS ROUTES START #

  get  'auth/steam/callback' => 'sessions#create' # for testing purposes (?)
  post 'auth/steam/callback' => 'sessions#create'
  get 'auth/failure'         => redirect('/')
  delete 'signout'           => 'sessions#destroy'
  # match '/signout', to: 'sessions#destroy', via: :delete

  # SESSIONS ROUTES END #


  #resources :user_listings

  root to: 'static_pages#home'

  match "/faq", to: "static_pages#faq", via: :get
  match "/about", to: "static_pages#about", via: :get
  # match "/contact", to: "static_pages#contact"

  match '/searched-items', to: 'search#show', via: :get
  match '/search', to: "user_listings#search", via: :get
  match '/reload', to: "user_listings#reload", via: :post

  match '/contact', to: "contact_messages#new", via: :get
  match '/signin', to: redirect('/auth/steam'), via: :get
  # match '/message_marked_as_read', to: "messages#marked_as_read"
  match '/block_user', to: "relationships#create", via: :get
  match '/unblock_user', to:  "relationships#update", via: :get
  match '/update', to: "users#update", via: :get

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
