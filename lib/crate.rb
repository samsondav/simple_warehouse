# frozen_string_literal: true

class Crate
  attr_reader :width, :height, :product_code

  def initialize(width, height, product_code)
    @width  = Integer width
    @height = Integer height
    @product_code = product_code

    assert_valid_dimensions
    assert_valid_product_code
  end

  def product_code?(product_code)
    @product_code == product_code
  end

  # NOTE: Use equal? to see if it is the exact same crate
  def ==(other)
    width == other.width &&
      height == other.height &&
      product_code == other.product_code
  end

  def inspect
    product_code
  end

  private

  def assert_valid_product_code
    raise ArgumentError, 'product_code must be a one letter string' unless product_code.is_a?(String) && product_code.length == 1
  end

  def assert_valid_dimensions
    raise ArgumentError, 'width and height must both be at least 1' unless width > 0 && height > 0
  end
end
