Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do 
        resources :vendors, only: [:index]
        collection do
          get :search
        end
        member do
          get :nearest_atms
        end
      end
      resources :vendors, only: [:show, :create, :update, :destroy]
      resources :market_vendors, only: [:create]
      resource :market_vendors, only: [:destroy]
    end
  end
end
