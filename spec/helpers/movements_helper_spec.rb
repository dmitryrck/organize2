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

  context '#total' do
    context 'when fee is a nil value' do
      let(:movement) do
        double(:Movement, value: 10, fee: nil)
      end

      it 'returns just value' do
        expect(total(movement)).to eq "$10.00"
      end
    end

    context 'when does not have fee' do
      let(:movement) do
        double(:Movement, value: 10, fee: 0)
      end

      it 'returns just value' do
        expect(total(movement)).to eq "$10.00"
      end
    end

    context 'when when value is less than 0.01' do
      let(:movement) do
        double(:Movement, value: 0.001, fee: 0)
      end

      it 'returns just value' do
        expect(total(movement)).to eq "$0.00100000"
      end
    end

    context 'when has fee' do
      let(:movement) do
        double(:Movement, value: 100, fee: 4.21, fee_kind: nil)
      end

      it 'returns value and fee' do
        expect(total(movement)).to match %r[\$100.00]
        expect(total(movement)).to match %r[\$4.210000]
      end
    end

    context 'when has value, fee value, and fee kind' do
      let(:movement) do
        double(:Movement, value: 100, fee: 4.21, fee_kind: 'network', fee_kind_humanize: 'Network')
      end

      it 'returns value and fee' do
        expect(total(movement)).to match %r[\$100.00]
        expect(total(movement)).to match %r[Network: \$4.210000]
      end
    end
  end
end
