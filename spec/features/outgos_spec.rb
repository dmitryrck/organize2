require 'rails_helper'

describe 'Outgo', type: :feature do
  before do
    visit '/'
  end

  it 'paginate' do
    Outgo.create description: 'Outgo#1',
      value: 100,
      paid_at: Date.current,
      chargeable: Account.create(name: 'Account#1')

    Outgo.create description: 'Outgo#2',
      value: 100,
      paid_at: 1.month.ago,
      chargeable: Account.create(name: 'Account#1')

    click_on 'Outgos'

    expect(page).to have_content 'Outgo#1'
    click_on 'Previous'
    expect(page).to have_content 'Outgo#2'
  end

  it 'create' do
    Account.create name: 'Account#1', start_balance: 10
    click_on 'Outgos'

    click_on 'New'

    fill_in 'Description', with: 'Outgo#1'
    fill_in 'Category', with: 'Food'
    expect(page).to have_field 'Paid at', with: Date.current.to_s
    fill_in 'Paid at', with: '2015-05-31'
    fill_in 'Value', with: '101'
    expect(page).to have_select 'Kind', selected: 'Account'
    select 'Account#1', from: '* Account'

    click_on 'Create'

    expect(page).to have_content 'Outgo was successfully created.'

    expect(page).to have_content 'Description: Outgo#1'
    expect(page).to have_content 'Kind: Account'
    expect(page).to have_content 'Account/Card: Account#1'
    expect(page).to have_content 'Category: Food'
    expect(page).to have_content 'Paid at: 2015-05-31'
  end

  it 'create to card', js: true do
    Card.create name: 'Card#1'

    click_on 'Outgos'

    click_on 'New'

    fill_in 'Description', with: 'Outgo#1'
    fill_in 'Category', with: 'Food'
    expect(page).to have_field 'Paid at', with: Date.current.to_s
    fill_in 'Value', with: '101'
    expect(page).to have_select 'Kind', selected: 'Account'
    select 'Card', from: 'Kind'
    select 'Card#1', from: 'Card'
    fill_in 'Paid at', with: '2015-01-31'
    page.driver.render '/tmp/page.png', full: true

    click_on 'Create'

    expect(page).to have_content 'Outgo was successfully created.'

    expect(page).to have_content 'Description: Outgo#1'
    expect(page).to have_content 'Account/Card: Card#1'
    expect(page).to have_content 'Category: Food'
    expect(page).to have_content 'Paid at: 2015-01-31'
  end

  it 'reender form if wrong (with correct chargeable selected)', js: true do
    Card.create name: 'Card#1'
    Account.create name: 'Account#1'

    click_on 'Outgos'

    click_on 'New'

    expect(page).to have_select 'Kind', selected: 'Account'
    select 'Card', from: 'Kind'
    select 'Card#1', from: '* Card'

    click_on 'Create'

    expect(page).to have_select 'Kind', selected: 'Card'
    expect(page).to have_select '* Card', selected: 'Card#1'
  end

  it 'duplicate' do
    outgo = Outgo.create description: 'Outgo#1',
      value: 25,
      paid_at: 7.days.ago,
      category: 'Category#1',
      chargeable: Account.create(name: 'Account#1')

    click_on 'Outgos'

    click_on outgo.id

    click_on 'Duplicate'

    expect(page).to have_field 'Description', with: 'Outgo#1'
    expect(page).to have_field 'Paid at', with: Date.current.to_s
    expect(page).to have_field 'Category', with: 'Category#1'
    expect(page).to have_select 'Kind', selected: 'Account'
    expect(page).to have_select 'Account', selected: 'Account#1'
    expect(page).to have_field 'Value', with: '25.0'

    expect(page).to have_button 'Create Outgo'
  end

  it 'update' do
    outgo = Outgo.create description: 'Outgo#1',
      value: 100,
      paid_at: Date.current,
      chargeable: Account.create(name: 'Account#1')

    click_on 'Outgos'

    click_on outgo.id

    click_on 'Edit'

    fill_in 'Description', with: 'Outgo#2'
    fill_in 'Paid at', with: '2014-12-31'

    click_on 'Update'

    expect(page).to have_content 'Outgo was successfully updated.'
    expect(page).to have_content 'Description: Outgo#2'
    expect(page).to have_content 'Paid at: 2014-12-31'
  end

  context 'confirm' do
    it 'can confirm' do
      outgo = Outgo.create description: 'Outgo#1',
        value: 10,
        paid_at: Date.current,
        paid: false,
        chargeable: Account.create(name: 'Account#1', balance: 100)

      click_on 'Outgos'
      click_link 'Confirm'
      expect(page).to have_content 'Successfully confirmed'

      visit edit_outgo_path(outgo)
      expect(page).to have_disabled_field 'Value'

      expect(outgo.chargeable.reload.balance).to eq 90.0
    end

    it 'cannot confirm if chargeable is a card' do
      outgo = Outgo.create description: 'Outgo#1',
        value: 10,
        paid_at: Date.current,
        paid: false,
        chargeable: Card.create(name: 'Account#1')

      click_on 'Outgos'
      click_link 'Confirm'
      expect(page).to have_content 'Wrong chargeable kind'
    end
  end

  context 'unconfirm' do
    it 'can unconfirm payment' do
      outgo = Outgo.create description: 'Outgo#1',
        value: 10,
        paid_at: Date.current,
        paid: true,
        chargeable: Account.create(name: 'Account#1', balance: 100.0)

      click_on 'Outgos'
      click_link 'Unconfirm'
      expect(page).to have_content 'Successfully unconfirmed'

      visit edit_outgo_path(outgo)
      expect(page).to have_field 'Value'

      expect(outgo.chargeable.reload.balance).to eq 110.0
    end

    it 'cannot unconfirm if chargeable is a card' do
      outgo = Outgo.create description: 'Outgo#1',
        value: 10,
        paid_at: Date.current,
        paid: true,
        chargeable: Card.create(name: 'Account#1')

      click_on 'Outgos'
      click_link 'Unconfirm'
      expect(page).to have_content 'Wrong chargeable kind'
    end
  end
end
