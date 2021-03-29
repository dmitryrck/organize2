class MovementRemapping < ApplicationRecord
  extend EnumerateIt

  validates :kind, :field_to_watch, :text_to_match, :kind_of_match, :field_to_change, :kind_of_change,
    :text_to_change, :order, presence: true

  has_enumeration_for :kind, with: MovementKind
  has_enumeration_for :kind_of_match
  has_enumeration_for :field_to_change, with: MovementField
  has_enumeration_for :field_to_watch, with: MovementField
  has_enumeration_for :kind_of_change

  scope :ordered, -> { order(:order) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def to_s
    "##{order} - #{text_to_match} → #{text_to_change}"
  end
end
