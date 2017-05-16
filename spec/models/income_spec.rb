require 'rails_helper'

RSpec.describe Income, type: :model do
  subject { build(:income) }

  it_behaves_like Movement
end
