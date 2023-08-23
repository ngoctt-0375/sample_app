Rails.application.routes.draw do
  get 'users/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get  "/help", to: "static_pages#help"
    get  "/about", to: "static_pages#about"
  end

end
