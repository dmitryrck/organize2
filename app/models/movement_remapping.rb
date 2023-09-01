class MovementRemapping < ApplicationRecord
  extend EnumerateIt


  def self.ransackable_attributes(auth_object = nil)
    %w[
      active
      field_to_change
      field_to_watch
      kind
      kind_of_change
      kind_of_match
      order
      text_to_change
      text_to_match
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

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
