require 'rails_helper'

RSpec.describe Income, type: :model do
  subject { build(:income) }

  it_behaves_like Movement

  context "#outgo?" do
    it { is_expected.not_to be_outgo }
  end

  context "#income?" do
    it { is_expected.to be_income }
  end
end
