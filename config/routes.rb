Rails.application.routes.draw do
  resources :accounts
  resources :incomes
  resources :outgos

  root to: 'outgos#index'
end
