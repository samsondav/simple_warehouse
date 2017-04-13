# frozen_string_literal: true

class Position
  attr_reader :x, :y
  def initialize(x, y)
    @x = Integer(x)
    @y = Integer(y)
  end

  def coordinates
    [@x, @y]
  end

  def ==(other)
    other.x == x &&
      other.y == y
  end

  def inspect
    "[#{x}, #{y}]"
  end
end
