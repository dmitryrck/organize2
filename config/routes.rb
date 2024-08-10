Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  authenticate :admin_user, ->(admin_user) { admin_user.present? } do
    mount Blazer::Engine, at: "blazer"
  end

  ActiveAdmin.routes(self)

  root to: "admin/outgos#index"
  resources :docs, only: %i[index show]
end
