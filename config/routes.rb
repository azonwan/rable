Rabel::Application.routes.draw do
  devise_for :users, :controllers => {:sessions => "sessions"}
  get 'settings' => 'users#edit'
  get 'member/:nickname' => 'users#show', :as => :member
  post 'member/:nickname/follow' => 'users#follow', :as => :follow_user
  post 'member/:nickname/unfollow' => 'users#unfollow', :as => :unfollow_user
  put 'users/update_account' => 'users#update_account', :as => :update_account
  put 'users/update_password' => 'users#update_password', :as => :update_password
  put 'users/update_avatar' => 'users#update_avatar', :as => :update_avatar
  get 'go/:key' => 'nodes#show', :as => :go
  get 't/:id' => 'topics#show', :as => :t
  get 'my/nodes' => 'users#my_nodes', :as => :my_nodes
  get 'my/topics' => 'users#my_topics', :as => :my_topics
  get 'my/following' => 'users#my_following', :as => :my_following
  get 'recent' => 'topics#recent', :as => :recent
  get 'changes' => 'topics#index', :as => :changes
  get 'page/:key' => 'pages#show', :as => :page
  get 'goodbye' => 'welcome#goodbye'
  resources :nodes do
    resources :topics
    resources :bookmarks
  end
  resources :topics do
    resources :comments
    resources :bookmarks
  end
  resources :bookmarks
  resources :notifications do
    collection do
      post 'all_read'
    end
    member do
      put 'read'
    end
  end
  namespace :admin do
    resources :planes do
      resources :nodes
    end
    resources :users do
      member do
        post :toggle_admin
      end
    end
    resources :topics
    resources :pages
    resources :advertisements
    root :to => 'welcome_admin#index'
  end
  root :to => 'welcome#index'
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
  # match ':controller(/:action(/:id(.:format)))'
end
