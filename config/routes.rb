Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users do
      member do
         get :following, :followers
      end
    end
    resources :password_resets, only: %i(new create edit update)
    resources :account_activations, only: :edit
    resources :microposts, only: %i(create destroy)
    resources :relationships, only: %i(create destroy)
  end

end
