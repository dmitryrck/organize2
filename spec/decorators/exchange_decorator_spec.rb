require "rails_helper"

describe ExchangeDecorator do
  subject { exchange.decorate }

  let(:exchange) do
    build(
      :exchange,
      value_in: 10, value_out: 12, fee: 1,
      fee_kind: fee_kind,
      source: source, destination: destination,
    )
  end

  let(:source) { build(:account, precision: 3, currency: "BRL") }
  let(:destination) { build(:account, precision: 4, currency: "USD") }

  context "when taking the fee from the source account" do
    let(:fee_kind) { ExchangeFeeKind::SOURCE }

    it { expect(subject.value_in).to eq "USD10.0000" }
    it { expect(subject.value_out).to eq "BRL12.000" }
    it { expect(subject.fee).to eq "BRL1.000" }
  end

  context "when taking the fee from the destination account" do
    let(:fee_kind) { ExchangeFeeKind::DESTINATION }

    it { expect(subject.value_in).to eq "USD10.0000" }
    it { expect(subject.value_out).to eq "BRL12.000" }
    it { expect(subject.fee).to eq "USD1.0000" }
  end
end
