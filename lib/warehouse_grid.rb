require_relative './position'
require_relative './crate'

class WarehouseGrid
  attr_reader :width, :height

  OutOfBounds = Class.new(StandardError)
  PositionOccupied = Class.new(StandardError)
  NoCrateHere = Class.new(StandardError)

  def initialize(width, height)
    @width  = Integer width
    @height = Integer height
    @grid = Array.new(@width) do
      Array.new(@height)
    end
  end

  def store(crate, position)
    raise unless crate.is_a?(Crate)
    raise unless position.is_a?(Position)

    x, y = position.coordinates
    raise OutOfBounds if x > @width || y > @height
    raise PositionOccupied unless @grid.dig(x, y).nil?

    @grid[position.x][position.y] = crate
  end

  def remove(position)
    crate = @grid[position.x][position.y]
    raise NoCrateHere if crate.nil?
    @grid[position.x][position.y] = nil
    crate
  end

  def positions_with_product_code(product_code)
    positions = []
    @grid.each_with_index do |row, x|
      row.each_with_index do |crate, y|
        positions << Position.new(x, y) if crate.product_code?(product_code)
      end
    end
    positions
  end
end
