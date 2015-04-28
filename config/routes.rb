DotaMarket::Application.routes.draw do


  concern :commentable do
    resources :comments
  end

  resources :users, concerns: :commentable do
    resources :messages do
      get "sent_messages", on: :collection
      get "conversation",  on: :collection
      member do 
        get 'marked_as_read'
      end
    end
   resources :user_listings
   resources :relationships, only: [:new, :create, :edit, :destroy]
 end

  resources :user_listings, concerns: :commentable
 
  resources :items
  resources :sessions, only: [:create, :destroy]

  # SESSIONS ROUTES START #

  get  'auth/steam/callback' => 'sessions#create' # for testing purposes (?)
  post 'auth/steam/callback' => 'sessions#create'
  get  'auth/failure'         => redirect('/')
  delete 'signout'           => 'sessions#destroy'
  # match '/signout', to: 'sessions#destroy', via: :delete

  # SESSIONS ROUTES END #


  #resources :user_listings

  root to: 'static_pages#home'

  ### SHAMEFUL ROUTES BELOW ###

  get "search/new"
  get "search/create"
  get "search/show"
  match '/searched-items', to: 'search#show', via: :get
  match '/search', to: "user_listings#search", via: :get

  match "/faq", to: "static_pages#faq", via: :get
  match "/about", to: "static_pages#about", via: :get
  # match "/contact", to: "static_pages#contact"

  match '/reload', to: "user_listings#reload", via: :post

  match '/contact', to: "contact_messages#new", via: :get
  match '/signin', to: redirect('/auth/steam'), via: :get
  # match '/message_marked_as_read', to: "messages#marked_as_read"
  match '/block_user', to: "relationships#create", via: :get
  match '/unblock_user', to:  "relationships#update", via: :get
  match '/update', to: "users#update", via: :get


  ### SHAMEFUL ROUTES END ###
end
