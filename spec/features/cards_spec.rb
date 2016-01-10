require 'rails_helper'

describe 'Card', type: :feature do
  before do
    visit '/'
  end

  it 'create' do
    click_on 'Cards'

    click_on 'New'

    expect(page).not_to have_field 'Active'
    fill_in 'Name', with: 'Card#1'
    fill_in 'Limit', with: '1000'
    fill_in 'Payment day', with: '15'

    click_on 'Create'

    expect(page).to have_content 'Card was successfully created.'

    expect(page).to have_content 'Name: Card#1'
    expect(page).to have_content 'Limit: $1,000.00'
    expect(page).to have_content 'Payment day: 15'
  end

  it 'update' do
    card = Card.create name: 'Card#1',
      limit: 100,
      payment_day: 15

    click_on 'Cards'

    click_on card.id

    click_on 'Edit'

    uncheck 'Active'
    fill_in 'Name', with: 'Card#2'
    fill_in 'Payment day', with: '1'

    click_on 'Update'

    expect(page).to have_content 'Card was successfully updated.'
    expect(page).to have_content 'Name: Card#2'
    expect(page).to have_content 'Payment day: 1'
    expect(page).to have_content 'Active: No'
  end

  it 'show only unpaid outgos' do
    card = Card.create name: 'Card#1',
      limit: 100,
      payment_day: 15

    Outgo.create description: 'Outgo#1',
      value: 100,
      paid_at: Date.current,
      paid: true,
      chargeable: card

    Outgo.create description: 'Outgo#2',
      value: 100,
      paid: false,
      paid_at: 1.month.ago,
      chargeable: card

    click_on 'Cards'
    click_on "##{card.id}"

    expect(page).not_to have_content 'Outgo#1'
    expect(page).to have_content 'Outgo#2'
  end

  it 'create a new outgo' do
    card = Card.create name: 'Card#1',
      limit: 100,
      payment_day: 15

    click_on 'Cards'

    click_on card.id

    click_on 'New'

    expect(page).to have_select 'Kind', selected: 'Card'
    expect(page).to have_select 'Card', selected: 'Card#1'
    expect(page).to have_field 'Paid at', with: Date.current.to_s
  end

  it 'show only unpaid movements' do
    card = Card.create name: 'Card#1',
      limit: 100,
      payment_day: 15

    Outgo.create(
      description: 'Food#1',
      chargeable: card,
      value: 25,
      paid_at: Date.current
    )

    Outgo.create(
      description: 'Food#2',
      chargeable: card,
      value: 25,
      paid: true,
      paid_at: Date.current
    )

    click_on 'Cards'

    click_on card.id

    expect(page).to have_content 'Food#1'
    expect(page).not_to have_content 'Food#2'
  end

  context 'when make a payment' do
    let!(:card) do
      Card.create(
        name: 'Card#1',
        limit: 100,
        payment_day: 15
      )
    end

    let!(:outgo1) do
      Outgo.create(
        description: 'Food#1',
        chargeable: card,
        value: 25,
        paid_at: Date.current
      )
    end

    let!(:outgo2) do
      Outgo.create(
        description: 'Food#2',
        chargeable: card,
        value: 50,
        paid_at: Date.current
      )
    end

    let!(:outgo3) do
      Outgo.create(
        description: 'Food#3',
        chargeable: card,
        value: 75,
        paid_at: 1.month.from_now
      )
    end

    let!(:outgo4) do
      Outgo.create(
        description: 'Food#4',
        chargeable: card,
        value: 100,
        paid: true,
        paid_at: Date.current
      )
    end

    before do
      Account.create name: 'Account#1', start_balance: 10

      click_on 'Cards'
      click_on "##{card.id}"
      click_on 'Create payment'
    end

    it 'correct shows only unpaid outgos value sum', js: true do
      find(:css, "#outgo_outgo_ids_#{outgo1.id}").set(true)
      find(:css, "#outgo_outgo_ids_#{outgo2.id}").set(true)
      find(:css, "#outgo_outgo_ids_#{outgo3.id}").set(false)

      expect(page).to have_field '* Value', with: '75'
    end

    it 'shows only unpaid outgos to form' do
      expect(page).to have_content 'Food#1 - 25'
      expect(page).to have_content 'Food#2 - 50'
      expect(page).to have_content 'Food#3 - 75'
      expect(page).not_to have_content 'Food#4 - 100'
    end

    it 'creates outgo with selected outgos', js: true do
      find(:css, "#outgo_outgo_ids_#{outgo1.id}").set(true)
      find(:css, "#outgo_outgo_ids_#{outgo2.id}").set(true)
      find(:css, "#outgo_outgo_ids_#{outgo3.id}").set(false)

      select 'Account', from: 'Kind'
      select 'Account#1', from: 'Account'

      fill_in 'Description', with: 'Outgo#1'

      click_on 'Create Outgo'

      expect(page).to have_content 'Food#1'
      expect(page).to have_content 'Food#2'
      expect(page).not_to have_content 'Food#3'
      expect(page).not_to have_content 'Food#4'
    end
  end
end
