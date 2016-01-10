Rails.application.routes.draw do
  resources :accounts

  resources :cards

  resources :incomes do
    member do
      get :confirm
      get :unconfirm
    end
  end

  resources :movements, only: [:show, :update]

  resources :outgos do
    member do
      get :confirm
      get :unconfirm
    end
  end

  resources :transfers do
    member do
      get :confirm
      get :unconfirm
    end
  end

  root to: 'outgos#index'
end
