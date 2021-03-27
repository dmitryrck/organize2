unless Rails.env.production?
  Movement.update_all(confirmed: false, parent_id: nil)
  Movement.destroy_all
  Exchange.update_all(confirmed: false)
  Exchange.destroy_all
  Transfer.update_all(confirmed: false)
  Transfer.destroy_all
  Account.destroy_all
end

2.times do
  Account.create(
    name: FFaker::Company.name,
    start_balance: rand(100),
  )
end

date_range = (-30..30).to_a

accounts = Account.all.to_a

50.times do |num|
  Movement.create!(
    description: "[#{FFaker::Food.fruit}] #{FFaker::Food.meat}",
    kind: %w(Outgo Income).sample,
    value: (rand(num * 2) + rand).round(2),
    category: FFaker::Color.name,
    date: Date.current + date_range.sample,
    confirmed: FFaker::Boolean.maybe,
    chargeable: accounts.sample,
    expected_movement: FFaker::Boolean.maybe,
  )
end

10.times do |num|
  exchange = Exchange.new(
    source: accounts.sample,
    destination: accounts.sample,
    value_in: (rand(num * 2) + rand).round(2),
    value_out: (rand(num * 2) + rand).round(2),
    date: Date.current + date_range.sample,
    confirmed: FFaker::Boolean.maybe,
    kind: ExchangeKind.list.sample,
  )
  exchange.save! if exchange.valid?

  transfer = Transfer.new(
    source: accounts.sample,
    destination: accounts.sample,
    value: (rand(num * 2) + rand).round(2),
    date: Date.current + date_range.sample,
    confirmed: FFaker::Boolean.maybe,
  )

  transfer.save! if transfer.valid?
end

AdminUser.find_or_create_by(email: "admin@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end
