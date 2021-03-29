class KindOfChange < EnumerateIt::Base
  associate_values(
    :replace,
    :append,
    :prepend,
  )
end
