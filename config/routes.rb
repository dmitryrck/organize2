Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "admin/outgos#index"
  resources :docs, only: %i[index show]
end
