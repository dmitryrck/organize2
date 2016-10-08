require 'rails_helper'

describe ElectrumImporter do
  subject do
    ElectrumImporter.new(csv_path: csv_path, account: account)
  end

  context '#import!' do
    let(:account) { create(:account) }

    let(:csv_path) { Rails.root.join('spec/fixtures/electrum1.csv') }

    context 'should correct import objects' do
      it { expect { subject.import! }.to change(Movement, :count).by(3) }
      it { expect { subject.import! }.to change(Outgo, :count).by(1) }
      it { expect { subject.import! }.to change(Income, :count).by(2) }
    end

    it 'should correct set balance' do
      expect { subject.import! }.to change(account, :balance).to 0.00000250
    end
  end

  context 'should reimport to account' do
    let(:account) { create(:account) }

    let(:csv_path1) { Rails.root.join('spec/fixtures/electrum1.csv') }

    before do
      importer = ElectrumImporter.new(csv_path: csv_path1, account: account)
      importer.import!
    end

    context 'the same file' do
      let(:csv_path) { csv_path1 }

      context 'should correct import objects' do
        it { expect { subject.import! }.to change(Movement, :count).by(0) }
        it { expect { subject.import! }.to change(Outgo, :count).by(0) }
        it { expect { subject.import! }.to change(Income, :count).by(0) }
      end

      it 'should correct set balance' do
        expect { subject.import! }.not_to change(account, :balance)
      end
    end

    context 'an updated version' do
      let(:csv_path) { Rails.root.join('spec/fixtures/electrum1-update.csv') }

      context 'should correct import objects' do
        it { expect { subject.import! }.to change(Movement, :count).by(3) }
        it { expect { subject.import! }.to change(Outgo, :count).by(2) }
        it { expect { subject.import! }.to change(Income, :count).by(1) }
      end

      it 'should correct set balance' do
        expect { subject.import! }.to change(account, :balance).to 0.00000246
      end
    end
  end
end
