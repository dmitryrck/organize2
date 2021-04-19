require "rails_helper"

describe "Incomes" do
  before { sign_in(user) }

  let(:user) { create(:admin_user) }

  it "should be able to create" do
    create(:account)

    click_on "Incomes"
    click_on "New"

    fill_in "Description", with: "Income#1"
    expect(page).to have_field "Date", with: Date.current.to_s
    fill_in "Date", with: "2017-12-31"
    fill_in "Value", with: 100
    select "Account#1", from: "income[chargeable_id]"

    click_on "Create"

    expect(page).to have_content("Income#1")
    expect(page).to have_content("$100.00")
    expect(page).to have_content("ACCOUNT Account#1")
    expect(page).to have_content("admin@example.com")
  end

  it "shows error message when user does not select chargeable" do
    click_on "Incomes"
    click_on "New"

    fill_in "Description", with: "Income#1"
    expect(page).to have_field "Date", with: Date.current.to_s
    fill_in "Date", with: "2017-12-31"
    fill_in "Value", with: 100

    click_on "Create"

    expect(page).to have_content "Account can't be blank"
  end

  context "when there is an income" do
    let!(:income) { create(:income) }

    it "should be able to update" do
      click_on "Incomes"
      within "#income_#{income.id}" do
        click_on "Edit"
      end

      fill_in "Description", with: "Income#2"
      fill_in "Value", with: "12.99"

      click_on "Update"

      expect(page).to have_content("Income#2")
      expect(page).to have_content("$12.99")
    end

    it "should be able to comment" do
      click_on "Incomes"
      within "#income_#{income.id}" do
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
      click_on "Incomes"
      within "#income_#{income.id}" do
        click_on "Delete"
      end
      page.driver.browser.switch_to.alert.accept

      expect(page).not_to have_content("Income#1")
    end

    it "duplicate" do
      click_on "Incomes"
      within "#income_#{income.id}" do
        click_on "View"
      end

      click_on "Duplicate"

      expect(page).to have_field "Description", with: "Income#1"
    end

    context "can't edit some fields" do
      it "if confirmed" do
        income.update_column(:confirmed, true)

        click_on "Incomes"
        within "#income_#{income.id}" do
          click_on "Edit"
        end

        expect(page).to have_field "income[chargeable_id]", disabled: true
        expect(page).to have_field "Value", disabled: true
      end
    end
  end
end
