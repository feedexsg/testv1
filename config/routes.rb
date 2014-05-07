Feedex::Application.routes.draw do

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable
  namespace :api, defaults: {format: 'json'} do
    resources :users do
      member do
        get :available_credits
      end
    end
    resources :menus
    resources :colonies
    resources :items do
      collection do
        get :available
        get :sort
      end
    end
    resources :orders do
      collection do
        post :redeem
      end
    end
    resources :credits
    resources :sessions, only: [:create, :destroy]
    match "*path", :to => "base#route_not_found", :via => :all
  end
  
  namespace :admin do
    root "menus#index"
    get 'dashboard' => 'pages#index'

    resources :items
    resources :users do
      member do
        get :credits
        patch :add_credits
      end
      collection do
        get :notify
      end
    end
    resources :sessions, only: [:new, :create, :destroy]
    resources :orders do
      collection do
        get :current
      end
    end
    resources :colonies
    resources :delivery_locations
    resources :menus

  end
  root "admin/menus#index"

end
