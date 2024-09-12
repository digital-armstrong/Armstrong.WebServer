Rails.application.routes.draw do
  root 'web/home#index'

  namespace :web do
    resources :asrc
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
