FactoryGirl.define do
  factory :trade do
    association :source, factory: :account, strategy: :cache
    association :destination, factory: :account2, strategy: :cache

    value_in 10
    value_out 20
    fee 1
    trade_at Date.current
    kind "Buy"

    factory :last_month_trade do
      value_in 120
      value_out 240
      trade_at 1.month.ago
    end

    trait :confirmed do
      confirmed true
    end
  end
end
