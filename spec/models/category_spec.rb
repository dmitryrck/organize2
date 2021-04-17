require "rails_helper"

describe Category do
  let(:nzd_account) { create(:account, currency: :NZD) }
  let(:brl_account) { create(:account, currency: :BRL) }

  context "#summary" do
    subject { Category.new(name: :supermarket) }

    let(:last_month) { Date.current.prev_month }
    let(:two_months_ago) { Date.current.prev_month(2) }

    before do
      create(
        :outgo,
        chargeable: nzd_account,
        category: :supermarket,
        value: 10,
        date: last_month,
        expected_movement: true,
      )

      create(
        :outgo,
        chargeable: nzd_account,
        category: :restaurant,
        value: 100,
        date: last_month,
        expected_movement: true,
      )

      create(
        :outgo,
        chargeable: nzd_account,
        category: :supermarket,
        value: 15,
        date: last_month,
        expected_movement: false,
      )

      create(
        :outgo,
        chargeable: brl_account,
        category: :supermarket,
        value: 20,
        date: two_months_ago,
        expected_movement: true,
      )

      create(
        :outgo,
        chargeable: brl_account,
        category: :restaurant,
        value: 120,
        date: two_months_ago,
        expected_movement: true,
      )

      create(
        :outgo,
        chargeable: nzd_account,
        category: :supermarket,
        value: 35,
        date: two_months_ago,
        expected_movement: false,
      )

      create(
        :outgo,
        chargeable: nzd_account,
        category: :restaurant,
        value: 135,
        date: two_months_ago,
        expected_movement: false,
      )

      create(
        :outgo,
        chargeable: nzd_account,
        category: :supermarket,
        value: 59,
        date: two_months_ago,
        expected_movement: true,
      )
    end

    it do
      expect(subject.summary).to include({
        month_currency: "#{I18n.l(last_month, format: :month)} (NZD)",
        expected_movement: 10,
        unexpected_movement: 15,
      })
    end

    it do
      expect(subject.summary).to include({
        month_currency: "#{I18n.l(two_months_ago, format: :month)} (BRL)",
        expected_movement: 20,
        unexpected_movement: 0,
      })
    end

    it do
      expect(subject.summary).to include({
        month_currency: "#{I18n.l(two_months_ago, format: :month)} (NZD)",
        expected_movement: 59,
        unexpected_movement: 35,
      })
    end
  end
end
