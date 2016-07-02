require 'rails_helper'

describe CreditCardReport do
  before do
    3.times do |number|
      Outgo.create(
        description: "Outgo##{number.succ}",
        chargeable: account,
        value: 100,
        category: 'loop',
        paid_at: Date.current,
      )
    end

    Outgo.create(
      description: "Outgo#4",
      chargeable: account,
      value: 50,
      category: 'alone',
      paid_at: Date.current,
    )

    Outgo.create(
      description: "Outgo#4",
      chargeable: account,
      value: -50,
      category: 'negative',
      paid_at: Date.current,
    )
  end

  subject { CreditCardReport.new(Outgo.all) }

  let(:account) { Account.create(start_balance: 0, name: 'Account#1') }

  it 'should return TODO' do
    expect(subject.chartjs).to eq [["loop", 300.0], ["alone", 50.0]]
  end
end
