MftDevise::Application.routes.draw do

  get "sessions/new"

  match '/about', to: 'pages#about'

  match '/contact', to: 'messages#new'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"

  devise_for :users, :controllers => { :sessions      => "sessions", 
  	                                   :registrations => 'registrations', 
  	                                   :invitations   => 'invitations' }
  resources :users, :messages

end