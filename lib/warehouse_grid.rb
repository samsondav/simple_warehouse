# frozen_string_literal: true

require_relative './position'
require_relative './crate'

class WarehouseGrid
  attr_reader :width, :height, :grid

  OutOfBounds      = Class.new(StandardError)
  PositionOccupied = Class.new(StandardError)
  NoCrateHere      = Class.new(StandardError)

  def initialize(width, height)
    @width  = Integer width
    @height = Integer height
    @grid = Array.new(@width) do
      Array.new(@height)
    end
  end

  def store(crate, position)
    assert_crate_in_bounds(crate, position)
    assert_position_unoccupied(position)

    (0...crate.width).each do |x_offset|
      (0...crate.height).each do |y_offset|
        @grid[position.x + x_offset][position.y + y_offset] = crate
      end
    end

    crate
  end

  def remove(position)
    assert_position_in_bounds(position)

    crate = @grid[position.x][position.y]

    @grid.each_with_index do |row, x|
      row.each_with_index do |this_crate, y|
        # Use `equal?` NOT `==` because we are looking for the exact same
        # object, not a matching size/product code
        next unless crate.equal?(this_crate)
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

  def view
    rendered = String.new

    @grid.reverse_each do |row|
      row.each do |crate|
        cell = crate.nil? ? '_' : crate.product_code
        rendered << cell
      end
      rendered << "\n"
    end

    rendered
  end

  private

  def assert_crate_in_bounds(crate, position)
    raise OutOfBounds if crate_out_of_bounds?(crate, position)
  end

  def assert_position_unoccupied(position)
    raise PositionOccupied if position_occupied?(position)
  end

  def assert_position_in_bounds(position)
    raise OutOfBounds if position_out_of_bounds?(position)
  end

  def crate_out_of_bounds?(crate, position)
    position.x + crate.width > @width || position.y + crate.height > @height
  end

  def position_occupied?(position)
    !@grid.dig(position.x, position.y).nil?
  end

  def position_out_of_bounds?(position)
    position.x > @width || position.y > @height
  end
end
