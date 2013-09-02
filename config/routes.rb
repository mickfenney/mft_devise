MftDevise::Application.routes.draw do

  get "sessions/new"

  get '/about', to: 'pages#about'

  get  '/contact', to: 'contact_us#new'
  post '/contact', to: 'contact_us#create', :as => :contact_us

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"

  devise_for :users, :controllers => { :sessions      => "sessions", 
  	                                   :registrations => 'registrations', 
  	                                   :invitations   => 'invitations' }
  resources :users

  resources :documents

  resources :document_types

  resources :galleries
  
  resources :pictures  

  resources :videos

  get "/delayed_job" => DelayedJobWeb, :anchor => false

end