require 'rails_helper'

describe 'Income', type: :feature do
  before do
    visit '/'
  end

  it 'create' do
    click_on 'Incomes'

    click_on 'New'

    fill_in 'Description', with: 'Income#1'
    fill_in 'Value', with: '101'

    click_on 'Criar'

    expect(page).to have_content 'Income criado com sucesso.'
  end

  it 'update' do
    income = Income.create description: 'Income#1', value: 100

    visit edit_income_path(income)

    fill_in  'Description', with: 'Income#2'

    click_on 'Atualizar'

    expect(page).to have_content 'Income atualizado com sucesso.'
    expect(page).to have_content 'Income#2'
  end
end
