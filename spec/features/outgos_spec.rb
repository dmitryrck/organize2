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
    fill_in 'Paid at', with: Date.current.to_s
    fill_in 'Value', with: '120.22'
    expect(page).to have_select 'Kind', selected: 'Account'
    select 'Account#1', from: '* Account'
    fill_in 'Fee', with: '4.17'
    select 'IOF', from: 'Fee kind'

    click_on 'Create'

    expect(page).to have_content 'Outgo was successfully created.'

    expect(page).to have_content 'Description: Outgo#1'
    expect(page).to have_content 'Value: $120.22'
    expect(page).to have_content 'Kind: Account'
    expect(page).to have_content 'Account/Card: Account#1'
    expect(page).to have_content 'Category: Food'
    expect(page).to have_content "Paid at: #{Date.current}"
    expect(page).to have_content 'Fee: $4.17000000 (IOF)'
  end

  it 'create with negative value' do
    Account.create name: 'Account#1', start_balance: 10
    click_on 'Outgos'

    click_on 'New'

    fill_in 'Description', with: 'Outgo#1'
    fill_in 'Category', with: 'Food'
    expect(page).to have_field 'Paid at', with: Date.current.to_s
    fill_in 'Paid at', with: '2015-05-31'
    fill_in 'Value', with: '-101'
    expect(page).to have_select 'Kind', selected: 'Account'
    select 'Account#1', from: '* Account'

    click_on 'Create'

    expect(page).to have_content 'Outgo was successfully created.'

    expect(page).to have_content 'Description: Outgo#1'
    expect(page).to have_content 'Value: -$101'
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

  context "can't edit value or kind" do
    it 'if paid' do
      outgo = Outgo.create description: 'Outgo#1',
        value: 100,
        paid_at: Date.current,
        paid: true,
        chargeable: Account.create(name: 'Account#1')

      click_on 'Outgos'

      click_on outgo.id

      click_on 'Edit'

      expect(page).to have_disabled_field 'Kind', select: true
      expect(page).to have_disabled_field 'Account', select: true
      expect(page).to have_disabled_field 'Value'
      expect(page).to have_disabled_field 'Fee'
    end

    it 'if chargeable is card and inactive' do
      outgo = Outgo.create description: 'Outgo#1',
        value: 100,
        paid_at: Date.current,
        chargeable: Card.create(name: 'Account#1', active: false)

      click_on 'Outgos'

      click_on outgo.id

      click_on 'Edit'

      expect(page).to have_disabled_field 'Kind', select: true
      expect(page).to have_disabled_field 'Card', select: true
      expect(page).to have_disabled_field 'Value'
      expect(page).to have_disabled_field 'Fee'
    end

    it 'if chargeable is account and inactive' do
      outgo = Outgo.create description: 'Outgo#1',
        value: 100,
        paid_at: Date.current,
        chargeable: Account.create(name: 'Account#1', active: false)

      click_on 'Outgos'

      click_on outgo.id

      click_on 'Edit'

      expect(page).to have_disabled_field 'Kind', select: true
      expect(page).to have_disabled_field 'Account', select: true
      expect(page).to have_disabled_field 'Value'
      expect(page).to have_disabled_field 'Fee'
    end
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
    let!(:outgo) do
      Outgo.create description: 'Outgo#1',
        value: 10,
        paid_at: Date.current,
        paid: false,
        chargeable: Account.create(name: 'Account#1', balance: 100)
    end

    it 'from index' do
      click_on 'Outgos'
      click_link 'Confirm'
      expect(page).to have_content 'Outgo was successfully confirmed'
      expect(page).to have_link 'Previous Month'
    end

    it 'from show' do
      click_on 'Outgos'
      click_on outgo.id
      click_link 'Confirm'
      expect(page).to have_content 'Outgo was successfully confirmed'
      expect(page).to have_content 'Description: Outgo#1'
    end

    it 'remove funds' do
      visit confirm_outgo_path(outgo)
      expect(outgo.chargeable.reload.balance).to eq 90.0
    end

    it 'remove funds when outgo has fee' do
      outgo.update(fee: 1)
      visit confirm_outgo_path(outgo)
      expect(outgo.chargeable.reload.balance).to eq 89.0
    end

    it 'should disable value field' do
      visit confirm_outgo_path(outgo)
      visit edit_outgo_path(outgo)
      expect(page).to have_disabled_field 'Value'
    end

    it 'should confirm sub outgos too' do
      suboutgo = Outgo.create(
        description: 'SubOutgo#1',
        value: 10,
        paid_at: Date.current,
        paid: false,
        parent: outgo,
        chargeable: Account.create(name: 'Account#2', balance: 100)
      )

      other_outgo = Outgo.create(
        description: 'Outgo#2',
        value: 10,
        paid_at: Date.current,
        paid: false,
        chargeable: Account.create(name: 'Account#3', balance: 100)
      )

      visit confirm_outgo_path(outgo)

      expect(suboutgo.reload).to be_paid
      expect(other_outgo.reload).not_to be_paid
    end

    it 'cannot confirm if chargeable is a card' do
      outgo.update(chargeable: Card.create(name: 'Card#1'))

      visit confirm_outgo_path(outgo)
      expect(page).to have_content 'Outgo has wrong chargeable kind'
    end

    it 'cannot confirm if it is already confirmed' do
      outgo.update(paid: true)

      visit confirm_outgo_path(outgo)
      expect(page).to have_content 'Outgo is already confirmed'
      expect(outgo.chargeable.reload.balance).to eq 100.0
    end
  end

  context 'can unconfirm' do
    let!(:outgo) do
      Outgo.create(
        description: 'Outgo#1',
        value: 10,
        paid_at: Date.current,
        paid: true,
        chargeable: Account.create(name: 'Account#1', balance: 100.0)
      )
    end

    it 'from index' do
      click_on 'Outgos'
      click_link 'Unconfirm'
      expect(page).to have_content 'Outgo was successfully unconfirmed'
      expect(page).to have_link 'Previous Month'
    end

    it 'from show' do
      click_on 'Outgos'
      click_on outgo.id
      click_link 'Unconfirm'
      expect(page).to have_content 'Outgo was successfully unconfirmed'
      expect(page).to have_content 'Description: Outgo#1'
    end

    it 'should disable value field' do
      visit unconfirm_outgo_path(outgo)
      visit edit_outgo_path(outgo)
      expect(page).to have_field 'Value'
    end

    it 'should update account balance' do
      visit unconfirm_outgo_path(outgo)

      expect(outgo.chargeable.reload.balance).to eq 110.0
    end

    it 'cannot unconfirm if chargeable is a card' do
      outgo.update(chargeable: Card.create(name: 'Account#1'))

      visit unconfirm_outgo_path(outgo)
      expect(page).to have_content 'Outgo has wrong chargeable kind'
    end
  end

  context 'delete' do
    it 'unpaid' do
      outgo = Outgo.create description: 'Outgo#1',
        value: 100,
        paid_at: Date.new(2015, 1, 1),
        chargeable: Account.create(name: 'Account#1')

      visit outgos_path(month: 1, year: 2015)
      click_on outgo.id
      click_on 'Delete'

      expect(page).to have_content 'Outgo was successfully destroyed'

      expect(page).to have_content '2015-01'
    end

    it 'paid' do
      outgo = Outgo.create description: 'Outgo#1',
        value: 100,
        paid_at: Date.new(2015, 1, 1),
        paid: true,
        chargeable: Account.create(name: 'Account#1')

      visit outgos_path(month: 1, year: 2015)
      click_on outgo.id
      click_on 'Delete'

      expect(page).to have_content "Outgo can't be destroyed"

      expect(page).to have_link 'Edit'
    end
  end
end
