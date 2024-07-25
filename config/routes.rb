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
      resources :slot, only: [:edit, :show]
    end
  end

  get 'user_index_path', to: 'users#index', as: 'user_index'
  get 'service_owner_index', to: 'service_owners#index', as: 'service_owner_index'
  get 'admin_index', to: 'admins#index', as: 'admin_index'

  root "users#home"
  get 'users/show', to: 'users#show'

  resources :service_owners, only: [:index, :add_service_center]
end
