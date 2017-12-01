require "rails_helper"

describe "Cards" do
  before { sign_in(user) }

  let(:user) { create(:admin_user) }

  context "index" do
    before do
      create(:card, name: "Card#1", active: true)
      create(:card, name: "Card#2", active: false)
      create(:card, name: "Card#3", active: false)

      click_on "Cards"
    end

    it "should filter by active" do
      click_on "Active"
      expect(page).to have_content "Card#1"
    end

    it "should filter by inactive" do
      click_on "Inactive"
      expect(page).to have_content "Card#2"
    end
  end

  it "should be able to create" do
    click_on "Cards"
    click_on "New"

    fill_in "Name", with: "Card#1"
    fill_in "Limit", with: 123.45
    fill_in "Payment day", with: 20
    fill_in "Precision", with: 4

    click_on "Create"

    expect(page).to have_content("Card#1") &
      have_content("$123.45") &
      have_content("PAYMENT DAY 20") &
      have_content("PRECISION 4")
  end

  context "when there is a card" do
    let!(:card) { create(:card) }

    it "should be able to update" do
      click_on "Cards"
      within "#card_#{card.id}" do
        click_on "Edit"
      end

      fill_in "Name", with: "Card#2"

      click_on "Update"

      expect(page).to have_content("Card#2")
    end

    it "should be able to comment" do
      click_on "Cards"
      within "#card_#{card.id}" do
        click_on "View"
      end

      fill_in "active_admin_comment[body]", with: "Comment#1"
      click_on "Add"

      within ".comments" do
        expect(page).to have_content("Comment#1") &
          have_content("admin@example.com")
      end
    end

    it "should be able to destroy" do
      click_on "Cards"
      within "#card_#{card.id}" do
        click_on "Delete"
      end

      expect(page).not_to have_content("Card#1")
    end

    it "show only unpaid outgos" do
      create(:outgo, chargeable: card, description: "Outgo#1")
      create(:outgo, chargeable: card, description: "Outgo#2", confirmed: true)

      click_on "Cards"
      within "#card_#{card.id}" do
        click_on "View"
      end

      expect(page).to have_content "Outgo#1"
      expect(page).not_to have_content "Outgo#2"
    end

    context "when make a payment" do
      let!(:outgo1) { create(:outgo, chargeable: card, description: "Outgo#1", value: 100) }
      let!(:outgo2) { create(:outgo, chargeable: card, description: "Outgo#2", confirmed: true) }
      let!(:outgo3) { create(:outgo, chargeable: card, description: "Outgo#3", value: 50) }
      let!(:outgo4) { create(:outgo, chargeable: card, description: "Outgo#4", value: 10) }

      before do
        create(:account)

        click_on "Cards"
        within "#card_#{card.id}" do
          click_on "View"
        end

        click_on "Make a payment"
      end

      it "should fills card select" do
        expect(page).to have_select "Card", selected: card.name
      end

      it "shows only unpaid outgos to form" do
        expect(page).to have_content("Outgo#1") &
          have_content("Outgo#3") &
          have_content("Outgo#4")

        expect(page).not_to have_content("Outgo#2")
      end

      it "correct shows only unpaid outgos value sum" do
        find(:css, "#outgo_outgo_ids_#{outgo1.id}").set(true)
        find(:css, "#outgo_outgo_ids_#{outgo3.id}").set(true)
        find(:css, "#outgo_outgo_ids_#{outgo4.id}").set(false)

        expect(page).to have_field "Value", with: "150"
      end

      it "creates outgo with selected outgos" do
        fill_in "Description", with: "Card payment"
        fill_in "Date", with: "2017-12-31"
        select "Account#1", from: "outgo[chargeable_id]"

        find(:css, "#outgo_outgo_ids_#{outgo1.id}").set(true)

        click_on "Create Outgo"

        expect(page).to have_content("Outgo was successfully created") &
          have_content("Outgo#1")
      end
    end
  end
end
