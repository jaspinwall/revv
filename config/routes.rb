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

  get 'stripe/oauth', to: 'stripe#oauth'
  get 'stripe/confirm', to: 'stripe#confirm'

end
