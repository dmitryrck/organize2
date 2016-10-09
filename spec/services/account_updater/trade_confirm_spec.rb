require 'rails_helper'

describe AccountUpdater::TradeConfirm do
  context '#confirm!' do
    subject { AccountUpdater::TradeConfirm.new(trade: trade) }

    let(:trade) { create(:trade) }

    it { expect { subject.update! }.to change { trade.destination.balance }.by(9) }
    it { expect { subject.update! }.to change { trade.source.balance }.by(-20) }
  end
end
