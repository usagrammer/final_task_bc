Rails.application.routes.draw do
  devise_for :users
  root to: "items#index"
  resources :items do
    resources :transactions, only: [:index, :new, :create]
    resources :comments, only: :create 
  end
end
