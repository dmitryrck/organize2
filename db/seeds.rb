Movement.update_all(confirmed: false)
Movement.destroy_all
Account.destroy_all

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
    expected_movement: [true, false].sample,
  )
end

AdminUser.find_or_create_by(email: "admin@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end
