require "rails_helper"

describe "Categories" do
  before { sign_in(user) }

  let(:user) { create(:admin_user) }
  let(:nzd_account) { create(:account, currency: :NZD) }
  let(:brl_account) { create(:account, currency: :BRL) }
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

  context "index page" do
    it "shows all categories" do
      click_on "Categories"

      expect(page).to have_content "supermarket"
      expect(page).to have_content "restaurant"
    end
  end

  context "show page" do
    it "shows the summary" do
      click_on "Categories"
      click_on "supermarket"

      expect(page).to have_content "supermarket"
      expect(page).to have_content "Summary is from 1 year ago ("

      expect(page).to have_content "MONTH & CURRENCY"
      expect(page).to have_content "$0.00"
      expect(page).to have_content "$10.00"
      expect(page).to have_content "$15.00"
      expect(page).to have_content "$20.00"
      expect(page).to have_content "$35.00"
      expect(page).to have_content "$59.00"
    end
  end
end
