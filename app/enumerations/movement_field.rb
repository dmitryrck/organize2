class MovementField < EnumerateIt::Base
  associate_values(
    :category,
    :description,
    :expected_movement,
    :paid_to,
    :parent_id,
  )
end
