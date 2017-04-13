# frozen_string_literal: true

require_relative './warehouse_grid'
require_relative './command'

$warehouse = nil

class App
  def run
    @live = true
    puts 'Type `help` for instructions on usage'
    while @live
      print '> '
      cmd_string = gets.chomp
      case cmd_string
      when 'help'
        show_help_message
      when 'exit'
        exit
      else
        execute(cmd_string)
      end
    end
  end

  private

  def execute(cmd_string)
    command = Command.parse(cmd_string)
    output = command.execute
    puts output
  rescue ArgumentError
    show_unrecognized_message
  end

  def show_help_message
    puts 'help             Shows this help message
init W H         (Re)Initialises the application as a W x H warehouse, with all spaces empty.
store X Y W H P  Stores a crate of product code P and of size W x H at position X,Y.
locate P         Show a list of positions where product code can be found.
remove X Y       Remove the crate at positon X,Y.
view             Show a representation of the current state of the warehouse, marking each position as filled or empty.
exit             Exits the application.'
  end

  def show_unrecognized_message
    puts 'Command not found. Type `help` for instructions on usage'
  end

  def exit
    puts 'Thank you for using simple_warehouse!'
    @live = false
  end

end
