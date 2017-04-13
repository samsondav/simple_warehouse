require_relative './position'
require_relative './crate'

class WarehouseGrid
  attr_reader :width, :height, :grid

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
    raise OutOfBounds if x + crate.width > @width || y + crate.height > @height
    raise PositionOccupied unless @grid.dig(x, y).nil?

    (0...crate.width).each do |x_offset|
      (0...crate.height).each do |y_offset|
        @grid[position.x + x_offset][position.y + y_offset] = crate
      end
    end

    crate
  end

  def remove(position)
    crate = @grid[position.x][position.y]

    @grid.each_with_index do |row, x|
      row.each_with_index do |this_crate, y|
        next unless crate.equal?(this_crate) # use `equal?` NOT `==` because we are looking for the exact same object, not a matching size/product code
        @grid[x][y] = nil
      end
    end

    raise NoCrateHere if crate.nil?
    @grid[position.x][position.y] = nil
    crate
  end

  def locate(product_code)
    positions       = Set.new
    recorded_crates = Set.new

    @grid.each_with_index do |row, x|
      row.each_with_index do |crate, y|
        next if crate.nil? || recorded_crates.include?(crate) || !crate.product_code?(product_code)

        # This records the correct position since we work upwards in width and
        # height, so we always get the bottom left corner of any one crate
        # first
        positions       << Position.new(x, y)
        recorded_crates << crate
      end
    end

    positions
  end
end
