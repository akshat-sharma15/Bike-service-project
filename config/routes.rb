Rails.application.routes.draw do
  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }

  resources :service_owners do
    resources :service_centers, only: [:create, :show]
  end

  resources :service_owners do
    resources :service_centers do
      resources :slots, only: [:index, :new, :create, :show]
    end
  end

  resources :service_owners do
    resources :service_centers do
      resources :bikes, only: [:create, :show]
    end
  end

  get 'client_user_index_path', to: 'client_users#index', as: 'user_index'
  get 'service_owner_index', to: 'service_owners#index', as: 'service_owner_index'
  get 'admin_index', to: 'admins#index', as: 'admin_index'

  root "users#home"
  get 'users/show', to: 'users#show'

  resources :service_centers, only: [:index]

  resources :service_owners, only: [:index, :add_service_center]
end
