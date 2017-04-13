require_relative '../lib/app'

RSpec.configure do |config|
  config.before(:example) do |_example|
    $warehouse = nil
  end
end
