class FeeKind < EnumerateIt::Base
  associate_values(
    :bank_transfer,
    :exchange,
    :iof,
    :network,
  )
end
