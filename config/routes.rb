Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { :omniauth_callbacks => 'omniauth_callbacks' }
  devise_scope :user do
    authenticated :user do
      root 'rentals#new'
      get '/', to:'rentals#new', as: :new_rental
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  get 'account', to: 'users#account'

  resources :books
  resources :rentals , only: [:destroy, :create, :index]

end
