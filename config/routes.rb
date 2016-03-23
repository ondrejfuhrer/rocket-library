Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    authenticated :user do
      root 'users#dashboard'
      get '/', to: 'users#dashboard', as: :dashboard
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :books do
    post 'search', on: :collection
    get '/:letter', on: :collection, as: :alphabetic_filter, to: 'books#index', constraints: { letter: /[a-z]/ }
  end

  resources :rentals, only: [:destroy, :create, :index, :new] do
    resources :watch_lists, only: [:create]
  end

  get '/reports', to: 'reports#index', as: :reports_index

end
