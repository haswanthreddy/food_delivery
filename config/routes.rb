Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  namespace :api do
    namespace :v1 do
      namespace :users do
        resource :sessions, only: %i[create destroy]
        resources :orders, only: [:index, :create, :show, :update]
      end
  
      namespace :delivery_partners do
        resource :sessions, only: %i[create destroy]
        resources :orders, only: [:show, :update] do
          member do
            post :accept
          end
        end
      end
  
      resources :users, only: %i[create show update]
      resources :delivery_partners, only: %i[create show update] do
        member do
          post :update_location
        end
      end

      resources :establishments, only: %i[index show] do
        resources :products, only: %i[index show]
      end
    end
  end
end
