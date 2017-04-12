require_relative './position'
require_relative './product'

class WarehouseGrid
  OutOfBounds = Class.new(StandardError)
  PositionOccupied = Class.new(StandardError)

  def initialize(width, height)
    @width = width
    @height = height
    @grid = Array.new(@width) do
      Array.new(@height)
    end
  end

  def store(product, position)
    raise unless product.is_a?(Product)
    raise unless position.is_a?(Position)
    raise OutOfBounds if x > @width || y > @height

    x, y = position.coordinates
    raise PositionOccupied unless @grid.dig(x, y).nil?
    @grid[position.x][position.y] = product
  end

  def positions_with_product_code(product_code)
    positions = []
    @grid.each_with_index do |row, x|
      row.each_with_index do |product, y|
        positions << Position.new(x, y) if product.code?(product_code)
      end
    end
    positions
  end
end
