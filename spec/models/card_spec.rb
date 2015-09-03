require 'rails_helper'

describe Card do
  subject do
    Card.new(name: 'Card#1')
  end

  it { is_expected.to be_valid }

  it 'should not be valid without name' do
    subject.name = nil

    expect(subject).not_to be_valid
  end

  it 'returns name as to_s' do
    expect(subject.to_s).to eq 'Card#1'
  end
end
