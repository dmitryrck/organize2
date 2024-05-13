FactoryBot.define do
  factory :transfer do
    association :source, factory: :account
    association :destination, factory: :account2

    value { 10 }
    fee { 1 }
    date { Date.current }

    trait :confirmed do
      confirmed { true }
    end
  end
end
