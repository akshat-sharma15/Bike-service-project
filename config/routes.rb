Rails.application.routes.draw do
  devise_for :users, controllers: {
        sessions: 'users/sessions'
      }

  root "users#index"
  get 'users/show', to: 'users#show'
end
