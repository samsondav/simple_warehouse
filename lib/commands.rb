class Command
  UnknownCommand = Class.new(StandardError)
  RequiresInitializedWarehouse = Class.new(StandardError)

  def self.parse(cmd_with_args)
    command, *args = cmd_with_args.split(' ')[0]
    case command
    when 'init'
      InitCommand.new(args)
    when 'store'
      StoreCommand.new
    when 'remove'
      RemoveCommand.new
    when 'view'
      ViewCommand.new
    else
      raise UnknownCommand
    end
  end

  def execute
    raise 'implement in a subclass'
  end

  private

  def assert_arguments_size(n, args)
    raise ArgumentError, "requires exactly #{n} arguments" unless args.size == n
  end

  def assert_warehouse_initialized
    raise RequiresInitializedWarehouse if $warehouse.nil?
  end
end

class InitCommand < Command
  def initialize(args)
    assert_arguments_size(2, args)
    integerified = args.map {|arg| Integer(arg) }
    @height, @width = *(integerified)
  end

  def execute
    $warehouse = WarehouseGrid.new(@height, @width)
  end
end

class StoreCommand < Command
  def initialize(args)
    assert_arguments_size(5, args)
    assert_warehouse_initialized

    @position    = Position.new(args[0], args[1])

    width        = args[2]
    height       = args[3]
    product_code = args[4]
    @product     = Product.new(width, height, product_code)
  end

  def execute
    $warehouse.store(@product, @position)
  end
end

class LocateCommand < Command
  def initialize(args)
    assert_arguments_size(1, args)
    assert_warehouse_initialized

    @product_code = args[0]
  end

  def execute
    positions = $warehouse.positions_with_product_code(@product)
    puts "Positions: #{positions.map(&:inspect).join(', ')}"
  end
end
