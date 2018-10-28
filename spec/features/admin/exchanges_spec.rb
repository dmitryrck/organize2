require "rails_helper"

describe "Exchanges" do
  before { sign_in(user) }

  let(:user) { create(:admin_user) }

  it "should be able to create" do
    Account.create name: "Account#1"
    Account.create name: "Account#2"

    click_on "Exchanges"
    click_on "New"

    select "Account#1", from: "Source"
    select "Account#2", from: "Destination"
    expect(page).to have_field "Date", with: Date.current
    fill_in "Value in", with: 100
    fill_in "Value out", with: 100
    fill_in "Fee", with: 10

    click_on "Create"

    expect(page).to have_content "Exchange was successfully created."

    expect(page).to have_content("SOURCE Account#1")
    expect(page).to have_content("DESTINATION Account#2")
    expect(page).to have_content("VALUE IN $100.00")
    expect(page).to have_content("VALUE OUT $100.00")
    expect(page).to have_content("FEE $10.00")
  end

  context "when there is a exchange" do
    let!(:exchange) { create(:exchange) }

    it "should be able to update" do
      click_on "Exchanges"
      within "#exchange_#{exchange.id}" do
        click_on "Edit"
      end

      fill_in "Value in", with: "100"

      click_on "Update"

      expect(page).to have_content("VALUE IN $100.00")
    end

    it "should block inputs if confirmed" do
      exchange.update_column(:confirmed, true)

      click_on "Exchanges"
      within "#exchange_#{exchange.id}" do
        click_on "Edit"
      end

      expect(page).to have_field "Kind", disabled: true
      expect(page).to have_field "Source", disabled: true
      expect(page).to have_field "Destination", disabled: true
      expect(page).to have_field "Value in", disabled: true
      expect(page).to have_field "Value out", disabled: true
      expect(page).to have_field "Fee", disabled: true
    end

    it "should be able to comment" do
      click_on "Exchanges"
      within "#exchange_#{exchange.id}" do
        click_on "View"
      end

      fill_in "active_admin_comment[body]", with: "Comment#1"
      click_on "Add"

      within ".comments" do
        expect(page).to have_content("Comment#1")
        expect(page).to have_content("admin@example.com")
      end
    end

    it "should link to a new form" do
      click_on "Exchanges"
      within "#exchange_#{exchange.id}" do
        click_on "View"
      end

      expect(page).to have_link "New Exchange"
    end

    context "when deleting" do
      context "when is not confirmed" do
        it "should destroy" do
          click_on "Exchanges"
          within "#exchange_#{exchange.id}" do
            click_on "Delete"
          end
          page.driver.browser.switch_to.alert.accept

          expect(page).to have_content("Exchange was successfully destroyed")
        end
      end

      context "when is confirmed" do
        before { exchange.update(confirmed: true) }

        it "should not destroy" do
          click_on "Exchanges"
          within "#exchange_#{exchange.id}" do
            click_on "Delete"
          end
          page.driver.browser.switch_to.alert.accept

          expect(page).to have_content("Account#1")
        end
      end
    end
  end
end
