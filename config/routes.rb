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

  resources :users do
    collection { post :import }
    collection { get :users }
  end

  resources :documents do
    collection { post :import }
    collection { get :documents }
  end

  resources :document_types do
    collection { post :import }
    collection { get :document_types }
  end

  resources :galleries
  
  resources :pictures  

  resources :videos do
    collection { post :import }
    collection { get :videos }
  end

  get "/delayed_job" => DelayedJobWeb, :anchor => false

end