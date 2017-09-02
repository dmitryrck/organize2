module AccountUpdater
  class Resolver
    def self.execute!(record, action: :confirm)
      base_class = record.model_name.name
      base_action = action.capitalize if %w[confirm unconfirm].include?(action)

      "AccountUpdater::#{base_class}#{base_action}".constantize.update!(record)
    end
  end
end
