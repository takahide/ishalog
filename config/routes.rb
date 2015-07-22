Ishalog::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get '/', to: 'top#index'
  get '/recommendations', to: 'top#recommendations'
  get '/recommend', to: 'recommendations#index'
  post '/recommend', to: 'recommendations#create'
  get '/login', to: 'top#login'
  get '/contact', to: 'contact#index'
  post '/contact', to: 'contact#create'
  get '/aboutus', to: 'top#aboutus'
  get '/search', to: 'top#search'

  get '/stations/suggest', to: 'station#suggest'
  get '/stations', to: 'station#show', as: 'stations_top'

  get '/admin', to: 'admin#recommendations'
  get '/admin/departments', to: 'admin#departments'
  get '/admin/departments/update', to: 'admin#edit_departments'


  get '*anything', to: 'errors#routing_error'

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
