Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: 'users/sessions' 
  }

    #show
    post "show/search/" => "show#schedule_search"
    get "show/:sharesche_key/pass" => "show#pass"
    get "show/:sharesche_key/input_pass" => "show#pass"
    post "show/:sharesche_key/input_pass" => "show#input_pass"
    get "show/:sharesche_key/:month" => "show#schedule"
    post "show/:sharesche_key/:month/follow_create" => "show#follow_create"
    post "show/:sharesche_key/:month/follow_destroy" => "show#follow_destroy"
    
  
    #like
    #post "likes/:post_id/create" => "likes#create"
    #post "likes/:post_id/destroy" => "likes#destroy"
  
    #user
    get "users/:id/withdraw" => "users#withdraw"
    delete "users/:id/destroy" => "users#destroy"
    post "users/:id/updatepass" => "users#updatepass"
    get "users/:id/editpass" => "users#editpass"
    post "users/:id/update" => "users#update"
    get "users/:id/edit" => "users#edit"
    post "users/create" => "users#create"
    get "users/create" => "users#new"
    get "signup" => "users#new"
    #get "users/index" => "users#index"
    #get "users/:id" => "users#show"
    post "login" => "users#login"
    post "logout" => "users#logout"
    get "login" => "users#login_form"
    #get "users/:id/likes" => "users#likes"
  
    #====ここから改修===============================
    root to: "home#top"
    post "/" => "show#schedule_search"
    get "/terms" => "home#terms"
    get "/policy" => "home#policy"

  resources :schedules do
    resources :bulk ,only:[:new,:create]
    resources :plans do
      resources :comment,only:[:new,:create,:edit,:update,:destroy]
    end
    #get ":month",to: "schedules#show" ,as: :month
  end
  
  namespace :follow do
    resources :schedules do
      collection do
        get :search
        get :password
        post :authentication
        #post :follow_create
        #delete :follow_destroy
      end
      member do
        #get :password
        #get :authentication
        post :follow_create
        delete :follow_destroy
      end
    end
  end
  resources :list do
    
  end

end
