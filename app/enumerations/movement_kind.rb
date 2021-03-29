class MovementKind < EnumerateIt::Base
  associate_values(
    income: "Income",
    outgo: "Outgo",
  )
end
