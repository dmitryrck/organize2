class FeeKind < EnumerateIt::Base
  associate_values :iof, :network, :bank_transfer
end
