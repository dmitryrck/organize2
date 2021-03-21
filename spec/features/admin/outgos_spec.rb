require "rails_helper"

describe "Outgos" do
  before { sign_in(user) }

  let(:user) { create(:admin_user) }

  context "when summarizing in the index page" do
    before do
      create(:outgo, date: 1.year.ago, value: 30)
      create(:outgo, value: 100)
      create(:outgo2, value: 20)
      create(:outgo2, description: "Groceries", value: 31, category: "supermarket")
      create(:outgo2, description: "Not in report", value: 42, in_reports: false)

      click_on "Outgos"
    end

    it "shows the correct labels for outgos" do
      expect(page).to have_content "Groceries SUPERMARKET"
      expect(page).to have_content "× Not in report"
    end

    it "should show correct value for the month" do
      within "#in_reports_sum_sidebar_section" do
        expect(page).to have_content "151"
      end

      within "#not_in_reports_sum_sidebar_section" do
        expect(page).to have_content "42"
      end
    end

    it "should show correct value for search" do
      fill_in "q_description", with: "Outgo#1"
      click_on "Filter"

      within "#in_reports_sum_sidebar_section" do
        expect(page).to have_content "130"
      end
    end
  end

  it "should be able to create" do
    create(:account)

    click_on "Outgos"
    click_on "New"

    fill_in "Description", with: "Outgo#1"
    expect(page).to have_field "Date", with: Date.current.to_s
    fill_in "Date", with: "2017-12-31"
    fill_in "Value", with: 100
    select "Account#1", from: "outgo[chargeable_id]"

    click_on "Create"

    expect(page).to have_content("Outgo#1")
    expect(page).to have_content("$100.00")
    expect(page).to have_content("$0.0")
    expect(page).to have_content("ACCOUNT/CARD Account#1")
  end

  context "when there is an outgo" do
    let!(:outgo) { create(:outgo) }

    it "should be able to update" do
      click_on "Outgos"
      within "#outgo_#{outgo.id}" do
        click_on "Edit"
      end

      fill_in "Description", with: "Outgo#2"
      fill_in "Value", with: "12.99"

      click_on "Update"

      expect(page).to have_content("Outgo#2")
      expect(page).to have_content("$12.99")
    end

    it "should be able to comment" do
      click_on "Outgos"
      within "#outgo_#{outgo.id}" do
        click_on "View"
      end

      fill_in "active_admin_comment[body]", with: "Comment#1"
      click_on "Add"

      within ".comments" do
        expect(page).to have_content("Comment#1")
        expect(page).to have_content("admin@example.com")
      end
    end

    it "should be able to destroy" do
      click_on "Outgos"
      within "#outgo_#{outgo.id}" do
        click_on "Delete"
      end
      page.driver.browser.switch_to.alert.accept

      expect(page).not_to have_content("Outgo#1")
    end

    it "duplicate" do
      click_on "Outgos"
      within "#outgo_#{outgo.id}" do
        click_on "View"
      end

      click_on "Duplicate"

      expect(page).to have_field "Description", with: "Outgo#1"
    end

    context "can't edit some fields" do
      it "if confirmed" do
        outgo.update_column(:confirmed, true)

        click_on "Outgos"
        within "#outgo_#{outgo.id}" do
          click_on "Edit"
        end

        expect(page).to have_field "outgo[chargeable_id]", disabled: true
        expect(page).to have_field "Value", disabled: true
        expect(page).to have_field "Fee", disabled: true
        expect(page).to have_field "Card", disabled: true
      end
    end
  end
end
