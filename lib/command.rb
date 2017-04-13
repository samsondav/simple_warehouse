# frozen_string_literal: true

class Command
  RECOGNIZED_COMMANDS = %w[init store locate remove view].freeze

  UnknownCommand               = Class.new(StandardError)
  RequiresInitializedWarehouse = Class.new(StandardError)

  def initialize(cmd_with_args)
    @command, *@args = cmd_with_args.split(' ')
  end

  def execute
    if RECOGNIZED_COMMANDS.include? @command
      send(@command, *@args)
    else
      raise UnknownCommand
    end
  end

  private

  def assert_warehouse_initialized
    raise RequiresInitializedWarehouse if $warehouse.nil?
  end

  def init(height, width)
    $warehouse = WarehouseGrid.new(height, width)
    'Done'
  end

  def store(x, y, width, height, product_code)
    assert_warehouse_initialized

    position = Position.new(x, y)
    crate    = Crate.new(width, height, product_code)

    $warehouse.store(crate, position)
    'Done'
  rescue WarehouseGrid::OutOfBounds
    "Can't store crate here, it exceeds the bounds of the warehouse!"
  rescue WarehouseGrid::PositionOccupied
    "There's already a crate here."
  end

  def locate(product_code)
    assert_warehouse_initialized

    positions = $warehouse.locate(product_code)
    "Positions: #{positions.map(&:inspect).join(', ')}"
  end

  def remove(x, y)
    assert_warehouse_initialized

    position = Position.new(x, y)

    $warehouse.remove(position)
    'Done'
  rescue WarehouseGrid::NoCrateHere
    "There's no crate at this position!"
  rescue WarehouseGrid::OutOfBounds
    'Those coordinates are outside of the warehouse!'
  end

  def view
    assert_warehouse_initialized

    $warehouse.view
  end
end
