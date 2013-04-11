MftDevise::Application.routes.draw do

  match '/about', to: 'pages#about'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end