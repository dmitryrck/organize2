class FindOutgos
  def self.list!(outgo)
    new(outgo).list
  end

  def initialize(outgo)
    @outgo = outgo
  end

  def list
    (Outgo.card.unconfirmed + @outgo.outgos)
      .uniq
      .sort { |x, y| [x.date, x.id] <=> [y.date, y.id] }
      .map { |outgo| outgo.decorate }
  end
end
