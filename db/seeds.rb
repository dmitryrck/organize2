Account.destroy_all
Movement.destroy_all

3.times do
  Account.create name: FFaker::Company.name,
    balance: rand(100)
end

date_range = (-90..60).to_a

50.times do |num|
  Movement.create! description: [FFaker::Food.fruit, FFaker::Food.ingredient, FFaker::Food.meat].join(' '),
    kind: %w(Outgo Income).sample,
    value: rand(num * 2) + rand,
    category: FFaker::Color.name,
    paid_at: Date.current + date_range.to_a.sample,
    paid: FFaker::Boolean.maybe,
    account: Account.all.to_a.sample
end
