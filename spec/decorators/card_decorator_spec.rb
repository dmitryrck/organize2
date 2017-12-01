require 'rails_helper'

describe CardDecorator do
  subject { card.decorate }

  let(:card) { build(:card, limit: 10, currency: "BRL", precision: 3) }

  describe ".limit" do
    it { expect(subject.limit).to eq "BRL10.000" }
  end
end
