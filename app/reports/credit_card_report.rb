class CreditCardReport
  def self.build(outgos)
    new(outgos).chartjs
  end

  def initialize(outgos)
    @outgos = outgos
  end

  def chartjs
    @outgos.group_by(&:category).map { |category, outgos|
      sum = outgos.sum(&:value).to_f

      if sum >= 0
        [category, sum]
      end
    }.reject(&:nil?)
  end
end
