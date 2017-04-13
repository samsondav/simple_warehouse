# frozen_string_literal: true

require_relative '../lib/app'
require 'pry'

RSpec.configure do |config|
  config.before(:example) do |_example|
    $warehouse = nil
  end
end
