Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: :registrations }

  scope :tournament do
    resources :predictions, only: %i[index]
    resources :games, only: %i[index]
  end

  resources :teams do
    member do
      get :leave
      get '/join/:token', to: 'teams#join', as: :join
    end
  end

  namespace :admin do
    resources :games, except: %i[new create destroy]
  end

  resource :dashboard, only: %i[show]
  resource :profile, only: %i[show update]

  root 'landing_page#index'
end
