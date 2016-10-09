require 'rails_helper'

describe ApplicationHelper do
  context '#numeric' do
    it { expect(numeric(1.1)).to eq '$1.10' }
    it { expect(numeric(0.001)).to eq '$0.00100000' }
  end
end
