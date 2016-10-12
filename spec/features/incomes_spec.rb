require 'rails_helper'

describe 'Income', type: :feature do
  before { visit '/' }

  it 'paginate' do
    Income.create description: 'Income#1',
      value: 100,
      paid_at: Date.current,
      chargeable: Account.create(name: 'Account#1')

    Income.create description: 'Income#2',
      value: 100,
      paid_at: 1.month.ago,
      chargeable: Account.create(name: 'Account#1')

    click_on 'Incomes'

    expect(page).to have_content 'Income#1'
    click_on 'Previous'
    expect(page).to have_content 'Income#2'
  end

  it 'search' do
    create(:income, description: 'Pizza day refund')
    create(:income, description: 'Pay day')
    create(:outgo, description: 'Pizza Outgo')

    click_on 'Incomes'

    fill_in 'q', with: 'Pizza'
    click_button 'Search'

    expect(page).to have_content 'Pizza day refund'
    expect(page).not_to have_content 'Pay day'
    expect(page).not_to have_content 'Pizza Outgo'
  end

  it 'create' do
    Account.create name: 'Account#1', start_balance: 10
    click_on 'Incomes'

    click_on 'New'

    fill_in 'Description', with: 'Income#1'
    fill_in 'Category', with: 'Food'
    expect(page).to have_field 'Paid at', with: Date.current.to_s
    fill_in 'Paid at', with: '2015-05-31'
    fill_in 'Value', with: '101'
    select 'Account#1', from: 'Account'

    click_on 'Create'

    expect(page).to have_content 'Income was successfully created.'

    expect(page).to have_content 'Description: Income#1'
    expect(page).to have_content 'Account: Account#1'
    expect(page).to have_content 'Category: Food'
    expect(page).to have_content 'Paid at: 2015-05-31'
  end

  it 'update' do
    income = Income.create description: 'Income#1',
      value: 100,
      paid_at: Date.current,
      chargeable: Account.create(name: 'Account#1')

    click_on 'Incomes'

    click_on income.id

    click_on 'Edit'

    fill_in 'Description', with: 'Income#2'
    fill_in 'Paid at', with: '2014-12-31'

    click_on 'Update'

    expect(page).to have_content 'Income was successfully updated.'
    expect(page).to have_content 'Description: Income#2'
    expect(page).to have_content 'Paid at: 2014-12-31'
  end

  context "can't edit value or kind" do
    it 'if paid' do
      income = Income.create description: 'Income#1',
        value: 100,
        paid_at: Date.current,
        paid: true,
        chargeable: Account.create(name: 'Account#1')

      click_on 'Incomes'

      click_on income.id

      click_on 'Edit'

      expect(page).to have_disabled_field 'Account', select: true
      expect(page).to have_disabled_field 'Value'
    end

    it 'if account is inactive', js: true do
      income = Income.create description: 'Income#1',
        value: 100,
        paid_at: Date.current,
        chargeable: Account.create(name: 'Account#1', active: false)

      click_on 'Incomes'

      click_on income.id

      click_on 'Edit'

      expect(page).to have_disabled_field 'Value'
      expect(page).to have_disabled_field 'Account', select: true
    end
  end

  it 'duplicate' do
    income = Income.create description: 'Income#1',
      value: 25,
      paid_at: 7.days.ago,
      category: 'Category#1',
      chargeable: Account.create(name: 'Account#1')

    visit incomes_path(year: income.year, month: income.month)
    click_on "##{income.id}"

    click_on 'Duplicate'

    expect(page).to have_field 'Description', with: 'Income#1'
    expect(page).to have_field 'Paid at', with: Date.current.to_s
    expect(page).to have_field 'Category', with: 'Category#1'
    expect(page).to have_select 'Account', selected: 'Account#1'
    expect(page).to have_field 'Value', with: '25.0'

    expect(page).to have_button 'Create Income'
  end

  context 'confirm' do
    let!(:income) do
      Income.create(
        description: 'Income#1',
        value: 10,
        paid_at: Date.current,
        paid: false,
        chargeable: Account.create(name: 'Account#1', balance: 100)
      )
    end

    it 'from index' do
      click_on 'Incomes'
      click_link 'Confirm'
      expect(page).to have_content 'Income was successfully confirmed'
      expect(page).to have_link 'Previous Month'
    end

    it 'from show' do
      click_on 'Incomes'
      click_on income.id
      click_link 'Confirm'
      expect(page).to have_content 'Income was successfully confirmed'
      expect(page).to have_content 'Description: Income#1'
    end

    it 'should disable value field' do
      visit confirm_income_path(income)

      visit edit_income_path(income)
      expect(page).to have_disabled_field 'Value'
    end

    it "should update account's balance" do
      visit confirm_income_path(income)

      expect(income.chargeable.reload.balance).to eq 110
    end

    it 'cannot confirm if it is already confirmed' do
      income.update(paid: true)

      visit confirm_income_path(income)
      expect(page).to have_content 'Income is already confirmed'
      expect(income.chargeable.reload.balance).to eq 100.0
    end
  end

  context 'unconfirm' do
    let!(:income) do
      Income.create(
        description: 'Income#1',
        value: 10,
        paid_at: Date.current,
        paid: true,
        chargeable: Account.create(name: 'Account#1', balance: 100)
      )
    end

    it 'from index' do
      click_on 'Incomes'
      click_link 'Unconfirm'
      expect(page).to have_content 'Income was successfully unconfirmed'
      expect(page).to have_link 'Previous Month'
    end

    it 'can unconfirm payment' do
      click_on 'Incomes'
      click_on income.id
      click_link 'Unconfirm'
      expect(page).to have_content 'Income was successfully unconfirmed'
      expect(page).to have_content 'Description: Income#1'
    end

    it 'should disable value field' do
      visit unconfirm_income_path(income)
      visit edit_income_path(income)
      expect(page).to have_field 'Value'
    end

    it "update account's balance" do
      visit unconfirm_income_path(income)
      expect(income.chargeable.reload.balance).to eq 90
    end
  end

  context 'delete' do
    it 'unpaid' do
      income = Income.create description: 'Income#1',
        value: 100,
        paid_at: Date.new(2015, 1, 1),
        chargeable: Account.create(name: 'Account#1')

      visit incomes_path(month: 1, year: 2015)
      click_on income.id
      click_on 'Delete'

      expect(page).to have_content 'Income was successfully destroyed'

      expect(page).to have_content '2015-01'
    end

    it 'paid' do
      income = Income.create description: 'Income#1',
        value: 100,
        paid_at: Date.new(2015, 1, 1),
        paid: true,
        chargeable: Account.create(name: 'Account#1')

      visit incomes_path(month: 1, year: 2015)
      click_on income.id
      click_on 'Delete'

      expect(page).to have_content "Income can't be destroyed"

      expect(page).to have_link 'Edit'
    end
  end
end
