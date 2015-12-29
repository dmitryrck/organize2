require 'rails_helper'

describe 'Income', type: :feature do
  before do
    visit '/'
  end

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

  it 'duplicate' do
    income = Income.create description: 'Income#1',
      value: 25,
      paid_at: 7.days.ago,
      category: 'Category#1',
      chargeable: Account.create(name: 'Account#1')

    click_on 'Incomes'

    click_on income.id

    click_on 'Duplicate'

    expect(page).to have_field 'Description', with: 'Income#1'
    expect(page).to have_field 'Paid at', with: Date.current.to_s
    expect(page).to have_field 'Category', with: 'Category#1'
    expect(page).to have_select 'Account', selected: 'Account#1'
    expect(page).to have_field 'Value', with: '25.0'

    expect(page).to have_button 'Create Income'
  end

  context 'confirm' do
    it 'can confirm' do
      income = Income.create description: 'Income#1',
        value: 10,
        paid_at: Date.current,
        paid: false,
        chargeable: Account.create(name: 'Account#1', balance: 100)

      click_on 'Incomes'
      click_link 'Confirm'
      expect(page).to have_content 'Successfully confirmed'

      visit edit_income_path(income)
      expect(page).to have_disabled_field 'Value'

      expect(income.chargeable.reload.balance).to eq 110
    end

    it 'cannot confirm if chargeable is a card' do
      income = Income.create description: 'Income#1',
        value: 10,
        paid_at: Date.current,
        paid: false,
        chargeable: Card.create(name: 'Account#1')

      click_on 'Incomes'
      click_link 'Confirm'
      expect(page).to have_content 'Wrong chargeable kind'
    end
  end

  context 'unconfirm' do
    it 'can unconfirm payment' do
      income = Income.create description: 'Income#1',
        value: 10,
        paid_at: Date.current,
        paid: true,
        chargeable: Account.create(name: 'Account#1', balance: 100)

      click_on 'Incomes'
      click_link 'Unconfirm'
      expect(page).to have_content 'Successfully unconfirmed'

      visit edit_income_path(income)
      expect(page).to have_field 'Value'

      expect(income.chargeable.reload.balance).to eq 90
    end

    it 'cannot unconfirm if chargeable is a card' do
      income = Income.create description: 'Income#1',
        value: 10,
        paid_at: Date.current,
        paid: true,
        chargeable: Card.create(name: 'Account#1')

      click_on 'Incomes'
      click_link 'Unconfirm'
      expect(page).to have_content 'Wrong chargeable kind'
    end
  end
end
