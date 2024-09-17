# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'home#index'

    resources :servers do
      scope module: :servers do
        resources :port, only: :create
      end

      member do
        post :start_polling, :stop_polling
      end
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
