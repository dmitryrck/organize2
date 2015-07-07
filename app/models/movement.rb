class Movement < ActiveRecord::Base
  self.inheritance_column = :kind

  validates :description, :value, :paid_at, presence: true
end
