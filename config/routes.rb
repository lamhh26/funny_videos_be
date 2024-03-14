Rails.application.routes.draw do
  devise_for :users, skip: :all
  defaults format: :json do
    devise_scope :user do
      post 'signup', to: 'registrations#create'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
    end

    resources :videos, only: %i[index create show]
    get 'current_user' => 'users#show'
  end

  mount ActionCable.server => '/cable'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
