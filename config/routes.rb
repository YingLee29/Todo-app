Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users, defaults: { format: :json }, skip: %i[sessions registrations]
  as :user do
    get "api/login", to: "api/sessions#create"
    delete "api/logout", to: "api/sessions#destroy"
    post "api/register", to: "api/registrations#create"
  end

  namespace :api, defaults: { format: :json } do
    resources :tasks, except: %i[index new edit] do
      member do
        patch :update_assignee
      end
    end

    resources :invitations, only: %i[index show create destroy] do
      member do
        patch :accept
        patch :reject
      end
      collection do
        get :users
      end
    end

    resources :categories do
      resources :tasks, only: %i[index]
    end

    resource :users do
      collection do
        get :linked
      end
    end
  end
end
