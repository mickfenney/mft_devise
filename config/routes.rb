MftDevise::Application.routes.draw do

  get "sessions/new"

  get "messages/new"

  match '/about', to: 'pages#about'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users, :controllers => { :sessions      => "sessions", 
  	                                   :registrations => 'registrations', 
  	                                   :invitations   => 'invitations' }
  resources :users, :messages

end