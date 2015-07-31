class Period
  attr_reader :year, :month

  def initialize(year, month)
    @year = year.to_s
    @month = format_month(month)
  end

  def year=(year)
    @year = year.to_s
  end

  def month=(month)
    @month = format_month(month)
  end

  def ==(other)
    self.to_s == other.to_s
  end

  def next
    @next ||= self.class.new(next_month.year, next_month.month)
  end

  def previous
    @previous ||= self.class.new(prev_month.year, prev_month.month)
  end
  alias :prev :previous

  def to_s
    "#{@year}-#{@month}"
  end

  protected

  def format_month(month)
    month.to_s.rjust(2, '0')
  end

  def next_month
    as_date.next_month
  end

  def prev_month
    as_date.prev_month
  end

  def as_date
    Date.new(@year.to_i, @month.to_i, 1)
  end
end
