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

  describe ".icon" do
    context "when it is buy" do
      before { trade.kind = "Buy" }

      it { expect(subject.icon).to eq %q[<i class="fa fa-shopping-cart" title="Buy"></i>] }
    end

    context "when it is sell" do
      before { trade.kind = "Sell" }

      it { expect(subject.icon).to eq %q[<i class="fa fa-money" title="Sell"></i>] }
    end
  end
end
