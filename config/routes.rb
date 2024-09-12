Rails.application.routes.draw do
  root 'web/home#index'

  get 'up' => 'rails/health#show', as: :rails_health_check
  post 'web/asrc', to: 'web/asrc#start_polling', as: :start_polling
  post '/web/asrc', to: 'web/asrc#stop_polling', as: :stop_polling
end
