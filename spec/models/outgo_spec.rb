require 'rails_helper'

RSpec.describe Movement, type: :model do
  subject { build(:outgo, chargeable: chargeable, chargeable_type: chargeable.class.name) }

  let(:chargeable) { build(:account) }

  it_behaves_like Movement

  context '#summarize?' do
    context 'with Account chargeable_type' do
      context 'and paid' do
        before { subject.paid = true }

        it { expect(subject).not_to be_summarize }
      end

      context 'and unpaid' do
        before { subject.paid = false }

        it { expect(subject).to be_summarize }
      end
    end

    context 'with Card chargeable_type' do
      let(:chargeable) { build(:card) }

      context 'and paid' do
        before { subject.paid = true }

        it { expect(subject).not_to be_summarize }
      end

      context 'and unpaid' do
        before { subject.paid = false }

        it { expect(subject).not_to be_summarize }
      end
    end
  end

  context '#to_s' do
    it 'should return description' do
      subject.description = 'Description#1'
      expect(subject.to_s).to eq 'Description#1'
    end
  end
end
