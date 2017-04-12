class Position
  attr_reader :x, :y
  def initialize(x, y)
    @x = Integer(x)
    @y = Integer(y)
  end

  def coordinates
    [@x, @y]
  end
end
