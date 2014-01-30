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

  namespace :admin do
    root "menus#index"

    resources :items
    resources :users do
      member do
        get :credits
        patch :add_credits
      end
    end
    resources :sessions, only: [:new, :create, :destroy]
    resources :orders
    resources :colonies
    resources :delivery_locations
    resources :menus

  end

end
