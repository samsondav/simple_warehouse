require_relative 'spec_helper'

RSpec.describe Command do
  describe 'init' do
    it 'initializes warehouse with correct size' do
      expect($warehouse).to be_nil

      Command.new('init 1 2').execute

      expect($warehouse).to be_a(WarehouseGrid)
      expect($warehouse.width).to eq(1)
      expect($warehouse.height).to eq(2)
    end

    it 'reinitializes warehouse with a different size, all spaces empty' do
      $warehouse = WarehouseGrid.new(4, 4)

      Command.new('init 1 2').execute

      expect($warehouse).to be_a(WarehouseGrid)
      expect($warehouse.width).to eq(1)
      expect($warehouse.height).to eq(2)
      expect($warehouse.grid.map(&:compact)).to all be_empty
    end
  end

  context '(with initialized warehouse)' do
    before(:each) do
      $warehouse = WarehouseGrid.new(5, 5)
    end

    describe 'store' do
      it 'calls WarehouseGrid#store with correct arguments' do
        expect($warehouse).to receive(:store).with(Crate.new(3, 4, 'A'), Position.new(1, 2))

        Command.new('store 1 2 3 4 A').execute
      end

      it 'renders correct output' do
        expect(Command.new('store 1 1 1 1 A').execute).to eq('Done')
      end
    end

    describe 'locate' do
      it 'calls WarehouseGrid#positions_with_product_code with correct arguments' do
        expect($warehouse).to receive(:positions_with_product_code).with('P') { Set.new() }

        Command.new('locate P').execute
      end

      it 'renders correct locations' do
        expect($warehouse).to receive(:positions_with_product_code) do
          [Position.new(0, 0), Position.new(1, 2), Position.new(5, 1)].to_set
        end

        expect(Command.new('locate P').execute).to eq("Positions: [0, 0], [1, 2], [5, 1]")
      end
    end
  end
end
