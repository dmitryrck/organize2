Rails.application.routes.draw do
  resources :accounts

  resources :incomes do
    member do
      get :confirm
      get :unconfirm
    end
  end

  resources :outgos do
    member do
      get :confirm
      get :unconfirm
    end
  end

  root to: 'outgos#index'
end
