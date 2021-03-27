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
      create(:outgo2, description: "Not in report", value: 42, expected_movement: false)

      click_on "Outgos"
    end

    it "shows the correct labels for outgos" do
      expect(page).to have_content "Groceries SUPERMARKET"
      expect(page).to have_content "× Not in report"
    end

    it "shows the correct summary" do
      within "#expected_expenses_sum_sidebar_section" do
        expect(page).to have_content "151"
      end

      within "#unexpected_expenses_sum_sidebar_section" do
        expect(page).to have_content "42"
      end

      within "#sum_sidebar_section" do
        expect(page).to have_content "193"
      end
    end

    it "should show correct value for search" do
      fill_in "q_description", with: "Outgo#1"
      click_on "Filter"

      within "#expected_expenses_sum_sidebar_section" do
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

  it "creates with a valid parent" do
    account = create(:account)
    parent = create(:outgo, description: "Parent#1", chargeable: account)

    click_on "Outgos"
    click_on "New"

    fill_in "Description", with: "Outgo#1"
    expect(page).to have_field "Date", with: Date.current.to_s
    fill_in "Date", with: "2017-12-31"
    fill_in "Value", with: 100
    select "Account#1", from: "outgo[chargeable_id]"
    fill_in "Parent", with: parent.id

    click_on "Create"

    expect(page).to have_content("Parent#1")
    expect(page).to have_content("Outgo#1")
    expect(page).to have_content("$100.00")
    expect(page).to have_content("$0.0")
    expect(page).to have_content("ACCOUNT/CARD Account#1")
  end

  it "shows error message when parent is invalid" do
    create(:account)

    click_on "Outgos"
    click_on "New"

    fill_in "Description", with: "Outgo#1"
    expect(page).to have_field "Date", with: Date.current.to_s
    fill_in "Date", with: "2017-12-31"
    fill_in "Value", with: 100
    select "Account#1", from: "outgo[chargeable_id]"
    fill_in "Parent", with: 9999

    click_on "Create"

    expect(page).to have_content("must exist")
  end

  context "when creating with repeat_expense" do
    before do
      create(:account)

      click_on "Outgos"
      click_on "New"
    end

    it "creates with valid params" do
      fill_in "Description", with: "Repeat#1"
      expect(page).to have_field "Date", with: Date.current.to_s
      fill_in "Date", with: "2017-12-31"
      fill_in "Value", with: 100
      select "Account#1", from: "outgo[chargeable_id]"
      fill_in "Repeat expense", with: "#{1.week.from_now.to_date.to_s}\n#{2.weeks.from_now.to_date.to_s}"

      click_on "Create"

      expect(page).to have_content("Repeat#1")
      expect(page).to have_content("$100.00")
      expect(page).to have_content("$0.0")
      expect(page).to have_content("ACCOUNT/CARD Account#1")

      expect(Outgo.count).to eq 3
    end

    it "does not create with missing mandatory params" do
      fill_in "Description", with: "Repeat#1"
      expect(page).to have_field "Date", with: Date.current.to_s
      fill_in "Date", with: "2017-12-31"
      select "Account#1", from: "outgo[chargeable_id]"
      fill_in "Repeat expense", with: "#{1.week.from_now.to_date.to_s}\n#{2.weeks.from_now.to_date.to_s}"

      click_on "Create"

      expect(page).to have_content("can't be blank")

      expect(Outgo.count).to be_zero
    end

    it "creates with date in the past" do
      fill_in "Description", with: "Repeat#1"
      expect(page).to have_field "Date", with: Date.current.to_s
      fill_in "Date", with: "2017-12-31"
      fill_in "Value", with: 100
      select "Account#1", from: "outgo[chargeable_id]"
      fill_in "Repeat expense", with: "#{1.week.ago.to_date.to_s}\n#{2.weeks.from_now.to_date.to_s}"

      click_on "Create"

      expect(page).to have_content("Repeat#1")
      expect(page).to have_content("$100.00")
      expect(page).to have_content("$0.0")
      expect(page).to have_content("ACCOUNT/CARD Account#1")

      expect(Outgo.count).to eq 3
    end
  end

  it "shows error message when user does not select chargeable" do
    click_on "Outgos"
    click_on "New"

    fill_in "Description", with: "Outgo#1"
    expect(page).to have_field "Date", with: Date.current.to_s
    fill_in "Date", with: "2017-12-31"
    fill_in "Value", with: 100

    click_on "Create"

    expect(page).to have_content "Account/Card can't be blank"
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
      expect(page).not_to have_content "Repeat expense"

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

        expect(page).not_to have_content "Repeat expense"
        expect(page).to have_field "outgo[chargeable_id]", disabled: true
        expect(page).to have_field "Value", disabled: true
        expect(page).to have_field "Fee", disabled: true
        expect(page).to have_field "Card", disabled: true
      end
    end

    it "set expected movement as true for selected outgos in batch" do
      outgo1 = create(:outgo, expected_movement: false)
      outgo2 = create(:outgo, expected_movement: false)

      click_on "Outgos"

      find("#batch_action_item_#{outgo1.id}").check
      find("#batch_action_item_#{outgo2.id}").check

      click_on "Batch Actions"
      click_on "Set As Expected Selected"

      expect(page).to have_content "Outgos updated successfully"

      [outgo1, outgo2].each do |outgo|
        within "#outgo_#{outgo.id}" do
          click_on "View"
        end

        expect(page).to have_content "EXPECTED EXPENSE YES"

        click_on "Outgos", match: :first
      end
    end

    it "set expected movement as false for selected outgos in batch" do
      outgo1 = create(:outgo, expected_movement: true)
      outgo2 = create(:outgo, expected_movement: true)

      click_on "Outgos"

      find("#batch_action_item_#{outgo1.id}").check
      find("#batch_action_item_#{outgo2.id}").check

      click_on "Batch Actions"
      click_on "Set As Unexpected Selected"

      expect(page).to have_content "Outgos updated successfully"

      [outgo1, outgo2].each do |outgo|
        within "#outgo_#{outgo.id}" do
          click_on "View"
        end

        expect(page).to have_content "EXPECTED EXPENSE NO"

        click_on "Outgos", match: :first
      end
    end
  end
end
