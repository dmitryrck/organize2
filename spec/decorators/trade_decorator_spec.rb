require 'rails_helper'

describe TradeDecorator do
  subject { trade.decorate }

  let(:trade) do
    build(
      :trade,
      value_in: 10, value_out: 12, fee: 1,
      source: source, destination: destination
    )
  end
  let(:source) { build(:account, precision: 3, currency: "BRL") }
  let(:destination) { build(:account, precision: 4, currency: "USD") }

  describe ".value_in" do
    it { expect(subject.value_in).to eq "USD 10.0000" }
  end

  describe ".value_out" do
    it { expect(subject.value_out).to eq "BRL 12.000" }
  end

  describe ".fee" do
    it { expect(subject.fee).to eq "USD 1.0000" }
  end
end
