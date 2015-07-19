require 'rails_helper'

describe 'Income', type: :feature do
  before do
    visit '/'
  end

  it 'create' do
    click_on 'Incomes'

    click_on 'New'

    fill_in 'Description', with: 'Income#1'
    fill_in 'Category', with: 'Food'
    expect(page).to have_field 'Paid at', with: Date.current.to_s
    fill_in 'Paid at', with: '2015-05-31'
    fill_in 'Value', with: '101'

    click_on 'Criar'

    expect(page).to have_content 'Income criado com sucesso.'

    expect(page).to have_content 'Description: Income#1'
    expect(page).to have_content 'Category: Food'
    expect(page).to have_content 'Paid at: 31/05/2015'
  end

  it 'update' do
    income = Income.create description: 'Income#1', value: 100, paid_at: Date.current

    visit edit_income_path(income)

    fill_in 'Description', with: 'Income#2'
    fill_in 'Paid at', with: '2014-12-31'

    click_on 'Atualizar'

    expect(page).to have_content 'Income atualizado com sucesso.'
    expect(page).to have_content 'Description: Income#2'
    expect(page).to have_content 'Paid at: 31/12/2014'
  end
end
