require 'csv'

namespace :import do
  task csv: :environment do
    Movement.transaction do
      [
        { filename: './files/outgos.csv', class_name: Outgo },
        { filename: './files/incomes.csv', class_name: Income },
      ].each do |import|
        CSV.foreach(import[:filename], col_sep: ',') do |row|
          next unless ['Sim', 'Não'].include?(row[1])

          account = Account.find_or_create_by(name: row[5])

          movement = import[:class_name].new(
            paid_at: Date.strptime(row[0], '%d/%m/%Y'),
            paid: row[1] == 'Sim',
            value: row[2].gsub('R$ ', '').gsub(',', '').to_f,
            description: row[3],
            category: row[4],
            chargeable: account,
          )

          unless movement.save
            puts movement.errors.inspect
          end
        end
      end
    end
  end
end
