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
  let(:source) { build(:account, precision: 3) }
  let(:destination) { build(:account, precision: 4) }

  describe ".value_in" do
    it { expect(subject.value_in).to eq "$10.000" }
  end

  describe ".value_out" do
    it { expect(subject.value_out).to eq "$12.0000" }
  end

  describe ".fee" do
    it { expect(subject.fee).to eq "$1.000" }
  end
end
