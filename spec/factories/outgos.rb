FactoryGirl.define do
  factory :outgo do
    association :chargeable, factory: :account, strategy: :cache

    description 'Outgo#1'
    value 100
    date { Date.current }

    factory :outgo2 do
      description 'Outgo#2'
    end

    factory :card_outgo do
      association :chargeable, factory: :card, strategy: :cache
    end
  end
end
