require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }

  resources :service_owners do
    resources :service_centers, only: [:create, :show]
  end

  resources :client_users, only: [:show, :index]

  resources :service_owners do
    resources :service_centers do
      resources :slots, only: [:index, :new, :create, :show, :update]
    end
  end

  resources :service_owners do
    resources :service_centers do
      resources :bikes, only: [:create, :show]
    end
  end

  resources :service_owners do
    resources :service_centers do
      resources :ratings, only: [:create, :index]
    end
  end

  resources :service_owners do
    resources :service_centers do
      resources :bikes do
        resources :bookings, only: [:create, :show, :new]
      end
    end
  end

  resources :service_owners do
    resources :service_centers do
      resources :bikes do
        member do
          post :need_full_service
          post :need_engine_service
          post :need_wash_service
          post :rental
          post :return
          post :avail
          post :not_available
        end
      end
    end
  end

  resources :service_owners do
    resources :service_centers do
      resources :slots do
        member do
          patch :confirm
          patch :service
          patch :complete
          patch :reject
          patch :waits
          patch :reset
          patch :cancle
        end
      end
    end
  end

  Rails.application.routes.draw do
    resources :service_owners do
      resources :service_centers do
        resources :bikes do
          resources :bookings do
            member do
              post :confirm
              post :activate
              post :complete
              post :reject
            end
          end
        end
      end
    end
  end

  resources :bikes, only: :index
  resources :slots, only: :index
  resources :bookings, only: :index

  get 'client_user_index_path', to: 'client_users#index', as: 'user_index'
  get 'service_owner_index', to: 'service_owners#index', as: 'service_owner_index'
  get 'admin_index', to: 'admins#index', as: 'admin_index'

  root "users#home"
  get 'users/show', to: 'users#show'
  get 'app/home', to: 'users#home'

  resources :service_centers, only: [:index, :search]
  get 'service_centers/search', to: 'service_centers#search', as: 'search_service_centers'
  resources :service_owners, only: [:index, :add_service_center]
end
