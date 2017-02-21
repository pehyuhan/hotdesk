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

  resources :users do
    resources :bookings do
      collection do
        post :book
      end
    end
  end
end
