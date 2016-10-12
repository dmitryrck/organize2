FactoryGirl.define do
  factory :income do
    association :chargeable, factory: :account, strategy: :cache

    description 'Income#1'
    value 100
    paid_at Date.current

    factory :income2 do
      description 'Income#2'
    end
  end
end
