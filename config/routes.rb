Rails.application.routes.draw do
  resources :incomes

  root to: 'incomes#index'
end
