class ExchangeFeeKind < EnumerateIt::Base
  associate_values(
    :source,
    :destination,
  )
end
