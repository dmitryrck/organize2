require 'rails_helper'

describe IncomeDecorator do
  subject { income.decorate }

  let(:income) { build(:income, value: 10, chargeable: account) }
  let(:account) { build(:account, precision: 3) }

  describe ".total" do
    it "should return value" do
      expect(subject.total).to eq "$10.000"
    end
  end
end
