class Crate
  attr_reader :width, :height, :product_code
  def initialize(width, height, product_code)
    @width  = Float width
    @height = Float height
    @product_code = product_code
  end

  def product_code?(product_code)
    @product_code == product_code
  end
end
