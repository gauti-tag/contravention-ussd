Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  match '/MMGG/UssdReception', to: 'main#index', via: [:get, :post]
  match '/MMGG/menu', to: 'main#index', via: [:get, :post]

  match '/MMGG/Mtn/UssdReception', to: 'mtn#index', via: [:get, :post]
end
