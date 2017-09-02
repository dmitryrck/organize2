require "rails_helper"

describe AccountUpdater::ExchangeConfirm do
  context "#confirm!" do
    subject { AccountUpdater::ExchangeUnconfirm.new(exchange) }

    let(:exchange) { create(:exchange) }

    it { expect { subject.update! }.to change { exchange.source.balance }.by(20) }
    it { expect { subject.update! }.to change { exchange.destination.balance }.by(-9) }
  end
end
