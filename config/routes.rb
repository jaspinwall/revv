Rails.application.routes.draw do

  root to: 'products#index'
  resources :charges
  post 'purchases/pay', to: 'purchases#pay'
  resources :purchases
  resources :buyers
  resources :products do
    member do
      get :pay
    end
  end
  resources :sellers
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'stripe/oauth', to: 'stripe#oauth'
  get 'stripe/confirm', to: 'stripe#confirm'
  get 'stripe/oauth_url', to: 'stripe#oauth_url'
  get 'stripe/verify!', to: 'stripe#verify!'

end
