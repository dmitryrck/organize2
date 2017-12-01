require "rails_helper"

describe MovementsDecorator do
  subject { MovementsDecorator.new([outgo.decorate, outgo2.decorate]) }

  let(:outgo) { build(:outgo, value: 10, fee: 1, confirmed: true) }
  let(:outgo2) { build(:outgo, value: 1, fee: 0) }
end
