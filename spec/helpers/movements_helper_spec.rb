require 'rails_helper'

describe MovementsHelper do
  context 'table_color' do
    context 'when chargeable type is card and unpaid'do
      let(:movement) do
        double(:Movement, chargeable_type: 'Card', paid?: true)
      end

      it 'returns info' do
        expect(table_color(movement)).to eq :info
      end
    end

    context 'when chargeable type is card and paid'do
      let(:movement) do
        double(:Movement, chargeable_type: 'Card', paid?: false)
      end

      it 'returns info' do
        expect(table_color(movement)).to eq :info
      end
    end

    context 'when chargeable type is not card and it is paid'do
      let(:movement) do
        double(:Movement, chargeable_type: 'Account', paid?: true)
      end

      it 'returns success' do
        expect(table_color(movement)).to eq :success
      end
    end

    context 'when chargeable type is not card and it is not paid'do
      let(:movement) do
        double(:Movement, chargeable_type: 'Account', paid?: false)
      end

      it 'returns success' do
        expect(table_color(movement)).to eq :warning
      end
    end
  end
end
