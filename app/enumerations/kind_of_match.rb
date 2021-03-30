class KindOfMatch < EnumerateIt::Base
  associate_values(
    :contains,
    :ends_with,
    :equals,
    :starts_with,
  )
end
