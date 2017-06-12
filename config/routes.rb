Rails.application.routes.draw do
   
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :galleries do
    collection { post :import }
  end
  devise_for :users, :controllers => {:registrations => "registrations"}
  root 'home#index'
  get '/contact_us', :to => 'home#contact_us'
  get '/about', :to => 'home#about'
  post '/edit_profile_image', :to=> "galleries#edit_profile_image"
   # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # match '*path' => 'home#error_404', via: :all
  
 

  namespace :api , :defaults => { :format => 'xml' } do
    namespace :v1 do
      devise_scope :user do
        post "/sign_in", :to => 'sessions#create'
        delete "/sign_out", :to => 'sessions#destroy'
        post "/sign_up", :to => 'registrations#create'
        post "/update_account", :to => 'registrations#update'
      end
      post '/contact_us', :to => 'home#contact_us'
      post '/gallery_create', :to => 'galleries#create'
      get '/gallery/:id', :to => 'galleries#record'
      match '*path' => 'home#error_404', via: :all
    end 
  end
end
