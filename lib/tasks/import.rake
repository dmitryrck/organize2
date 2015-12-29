require 'csv'

#
# rake import:json
#
namespace :import do
  task csv: :environment do
    Movement.transaction do
      CSV.foreach('./outgos.csv', col_sep: ',') do |row|
        next unless ['Sim', 'Não'].include?(row[1])

        account = Account.find_or_create_by(name: row[5])

        Outgo.create!(
          paid_at: Date.strptime(row[0], '%d/%m/%Y'),
          paid: row[1] == 'Sim',
          value: row[2].gsub('R$ ', '').to_f,
          description: row[3],
          category: row[4],
          chargeable: account,
        )
      end

      CSV.foreach('./incomes.csv', col_sep: ',') do |row|
        next unless ['Sim', 'Não'].include?(row[1])

        account = Account.find_or_create_by(name: row[5])

        Income.create!(
          paid_at: Date.strptime(row[0], '%d/%m/%Y'),
          paid: row[1] == 'Sim',
          value: row[2].gsub('R$ ', '').to_f,
          description: row[3],
          category: row[4],
          chargeable: account,
        )
      end
    end
  end
end

namespace :import do
  task json: :environment do
    Movement.transaction do
      arr = Oj.load(File.read('./dump.json'))

      arr[:movements].each do |hash|
        chargeable = hash[:chargeable_type].constantize
        .find_or_initialize_by(name: hash[:chargeable_name])
        if chargeable.new_record? && chargeable.is_a?(Account)
          chargeable.start_balance = 0.0
          chargeable.balance = 0.0
        end

        attributes = hash.reject { |k| [:chargeable_name, :chargeable_type].include?(k) }
        movement = Movement.new(attributes)
        movement.chargeable = chargeable
        movement.save!
      end

      arr[:transfers].each do |hash|
        source = hash[:source_type].constantize
        .find_or_initialize_by(name: hash[:source_name])
        if source.new_record? && source.is_a?(Account)
          source.start_balance = 0.0
          source.balance = 0.0
        end

        destination = hash[:destination_type].constantize
        .find_or_initialize_by(name: hash[:destination_name])
        if destination.new_record? && destination.is_a?(Account)
          destination.start_balance = 0.0
          destination.balance = 0.0
        end

        attributes = hash.reject do |key|
          [
            :source_name, :source_type,
            :destination_name, :destination_type
          ].include?(key)
        end
        transfer = Transfer.new(attributes)
        transfer.source = source
        transfer.destination = destination
        transfer.save!
      end
    end
  end
end
