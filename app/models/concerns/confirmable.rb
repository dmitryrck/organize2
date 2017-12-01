module Confirmable
  extend ActiveSupport::Concern

  included do
    scope :unconfirmed, -> { where(confirmed: false) }

    before_destroy do |record|
      if record.confirmed?
        errors.add(:base, "Cannot delete")
        throw(:abort) if errors.present?
      end
    end
  end
end
