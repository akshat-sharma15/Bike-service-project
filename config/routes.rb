Rails.application.routes.draw do
  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }

  get 'user_index_path', to: 'users#index', as: 'user_index'
  get 'service_owner_index', to: 'service_owners#index', as: 'service_owner_index'
  get 'admin_index', to: 'admins#index', as: 'admin_index'

  root "users#home"
  get 'users/show', to: 'users#show'
end
