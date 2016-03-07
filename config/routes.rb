Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { :omniauth_callbacks => 'omniauth_callbacks' }
  devise_scope :user do
    authenticated :user do
      root 'users#dashboard'
      get '/', to:'users#dashboard', as: :dashboard
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :books do
    post 'search', on: :collection
  end

  resources :rentals , only: [:destroy, :create, :index. :new]

end
