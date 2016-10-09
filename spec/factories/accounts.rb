FactoryGirl.define do
  factory :account do
    name 'Account#1'
    start_balance 0.0
    balance 0.0

    factory :account2 do
      name 'Account#2'
    end
  end
end
