require 'rails_helper'

describe 'Pendings', type: :feature do
  before { visit '/' }

  it 'should list outgos' do
    create(:outgo)
    create(:outgo2)

    click_on 'Pendings'

    expect(page).to have_content 'outgos'
    expect(page).to have_content 'Outgo#1'
    expect(page).to have_content 'Outgo#2'
    expect(page).to have_content '2 items left'
  end

  it 'should list incomes' do
    create(:income)
    create(:income2)

    click_on 'Pendings'

    expect(page).to have_content 'incomes'
    expect(page).to have_content 'Income#1'
    expect(page).to have_content 'Income#2'
    expect(page).to have_content '2 items left'
  end

  it 'should list transfers' do
    pending
    create_list(:transfer, 3)

    click_on 'Pendings'

    expect(page).to have_content 'transfer'
    expect(page).to have_content '3 items left'
  end
end
