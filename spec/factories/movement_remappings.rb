FactoryBot.define do
  factory :movement_remapping do
    active { true }
    order { 1 }
    kind { MovementKind::OUTGO }
    field_to_watch { MovementField::DESCRIPTION }
    kind_of_match { KindOfMatch::CONTAINS }
    text_to_match { "market" }
    kind_of_change { KindOfChange::PREPEND }
    field_to_change { MovementField::CATEGORY }
    text_to_change { "supermarket" }
  end
end
