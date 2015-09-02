class Card < ActiveRecord::Base
  validates :name, presence: true

  scope :ordered, -> { order(:name) }
end
