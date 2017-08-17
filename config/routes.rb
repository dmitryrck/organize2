Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :accounts

  resources :cards

  resources :incomes do
    member do
      get :confirm
      get :unconfirm
    end
  end

  resources :pendings, only: :index

  resources :outgos do
    member do
      get :confirm
      get :unconfirm
    end
  end

  resources :trades do
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
