require 'rails_helper'

describe AccountUpdater::TradeConfirm do
  context '#confirm!' do
    subject { AccountUpdater::TradeUnconfirm.new(trade) }

    let(:trade) { create(:trade) }

    it { expect { subject.update! }.to change { trade.source.balance }.by(20) }
    it { expect { subject.update! }.to change { trade.destination.balance }.by(-9) }
  end
end
