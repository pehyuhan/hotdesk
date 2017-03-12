Rails.application.routes.draw do

  devise_scope :user do
  	authenticated :user do
  		root 'bookings#index', as: :authenticated_root
  	end

  	unauthenticated do
  		root 'devise/sessions#new', as: :unauthenticated_root
  	end
  end

  devise_for :users
  
  resources :desks

  post '/users/:user_id/bookings/:id', :to => 'bookings#show'
  post '/users/:user_id/bookings/new', :to => 'bookings#new'

  resources :users do
    resources :bookings do
      collection do
        get :check_availability
        post :check_availability
      end
    end
  end
end
