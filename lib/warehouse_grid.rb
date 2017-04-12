require_relative './product'

class WarehouseGrid
  def initialize(width, height)
    @width = width
    @height = height
  end

  def store(product, x, y)
    raise unless product.is_a?(Product)
  end
end
