require "rails_helper"

describe MovementsDecorator do
  subject { MovementsDecorator.new([outgo.decorate, outgo2.decorate]) }

  let(:outgo) { build(:outgo, value: 10, fee: 1, paid: true) }
  let(:outgo2) { build(:outgo, value: 1, fee: 0) }

  describe ".regular_and_paid_value" do
    it { expect(subject.regular_and_paid_value).to eq 11 }

    context "when one of fees is nil" do
      let(:outgo) { build(:outgo, value: 10, fee: nil, paid: true) }

      it { expect(subject.regular_and_paid_value).to eq 10 }
    end
  end
end
