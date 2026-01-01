Rails.application.routes.draw do
  devise_for :users

  resources :residences do
    member do
      patch :restore
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root - Dashboard (redirects based on role in Phase 3/4)
  root "dashboard#index"
end
