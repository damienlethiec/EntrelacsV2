Rails.application.routes.draw do
  devise_for :users

  resources :users, except: [:show], path: "admin/users", as: :admin_users

  resources :stats, only: [:index, :show]

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
  get "up" => "health#show", :as => :health_check

  # Mobile app configuration (path configuration + tabs par rôle)
  get "/mobile/config" => "mobile#show"

  # Page compte utilisateur (cible du tab "Compte" de l'app mobile)
  get "/account" => "account#show"

  # Page politique de confidentialité (publique, pour Play Console)
  get "/privacy" => "pages#privacy"

  # Root - Dashboard (redirects based on role)
  root "dashboard#index"
end
