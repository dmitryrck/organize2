FactoryBot.define do
  factory :admin_user do
    email { "admin@example.com" }
    password { "secret" }
    password_confirmation { "secret" }
  end
end
