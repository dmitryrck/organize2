Rails.application.routes.draw do
  resources :accounts
  resources :incomes

  root to: 'incomes#index'
end
