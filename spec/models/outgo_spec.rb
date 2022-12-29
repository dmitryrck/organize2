require 'rails_helper'

RSpec.describe Movement, type: :model do
  subject { build(:outgo, chargeable: chargeable, chargeable_type: chargeable.class.name, admin_user: admin_user) }

  let(:chargeable) { build(:account) }
  let(:admin_user) { build(:admin_user) }

  it_behaves_like Movement

  context "#outgo?" do
    it { is_expected.to be_outgo }
  end

  context "#income?" do
    it { is_expected.not_to be_income }
  end
end
