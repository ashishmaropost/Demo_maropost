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
end
