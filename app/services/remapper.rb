class Remapper
  def initialize(movement, mappings: MovementRemapping.active.ordered)
    @movement = movement
    @mappings = mappings
  end

  def self.call(movement, mappings: MovementRemapping.active.ordered)
    new(movement, mappings: mappings).call
  end

  def call
    sorted_mappings.each do |mapping|
      next if movement.kind != mapping.kind

      if RemapperHelper.valid?(mapping: mapping, movement: movement)
        RemapperHelper.apply(mapping: mapping, movement: movement)
      end
    end
  end

  private

  attr_reader :movement, :mappings

  def sorted_mappings
    @sorted_mappings ||= mappings.sort_by(&:order)
  end
end
