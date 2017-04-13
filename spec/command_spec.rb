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
      expect($warehouse.instance_variable_get(:@grid).map(&:compact)).to all be_empty
    end
  end

  context 'with initialized warehouse' do
    before(:each) do
      $warehouse = WarehouseGrid.new(5, 5)
    end

    describe 'store' do
      it 'stores a crate of product number at the specified position' do
        Command.new('store 2 2 50 60 ABC').execute

        crate = $warehouse.remove(Position.new(2, 2))

        expect(crate.height).to eq(60)
        expect(crate.width).to eq(50)
        expect(crate.product_code).to eq('ABC')
      end

      it 'does not store crate if one is already present' do
        Command.new('store 2 2 50 60 ABC').execute

        expect do
          Command.new('store 2 2 50 60 ABC').execute
        end.to raise_error(WarehouseGrid::PositionOccupied)
      end
    end

    describe 'locate' do
      it 'Show a list of positions where product code P can be found'
    end
  end
end
