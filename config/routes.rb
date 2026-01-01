Rails.application.routes.draw do
  devise_for :users

  resources :users, except: [:show], path: "admin/users", as: :admin_users

  resources :residences, except: [:show] do
    member do
      patch :restore
    end

    resources :activities, except: [:destroy] do
      member do
        patch :cancel
        patch :complete
      end
    end

    resources :residents
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root - Dashboard (redirects based on role in Phase 3/4)
  root "dashboard#index"
end
