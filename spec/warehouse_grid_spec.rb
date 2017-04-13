require 'spec_helper'

RSpec.describe WarehouseGrid do
  let(:warehouse) do
    described_class.new(5, 5)
  end

  describe '#store' do
    let(:crate) {  }

    it 'raises out of bounds if x value is outside grid' do
      position = Position.new(10, 2)
      crate = Crate.new(1, 1, 'A')

      expect { warehouse.store(crate, position) }.to raise_error(WarehouseGrid::OutOfBounds)
    end

    it 'raises out of bounds if y value is outside grid' do
      position = Position.new(2, 10)
      crate = Crate.new(1, 1, 'A')

      expect { warehouse.store(crate, position) }.to raise_error(WarehouseGrid::OutOfBounds)
    end

    it 'raises out of bounds if crate is too large' do
      position = Position.new(0, 0)
      crate = Crate.new(10, 10, 'A')

      expect { warehouse.store(crate, position) }.to raise_error(WarehouseGrid::OutOfBounds)
    end

    it 'stores a crate of product number at the specified position' do
      position = Position.new(2, 2)
      crate = Crate.new(2, 2, 'A')

      warehouse.store(crate, position)

      expect(warehouse.grid[0][0]).to be_nil
      expect(warehouse.grid[2][2]).to eq crate
      expect(warehouse.grid[3][2]).to eq crate
      expect(warehouse.grid[4][2]).to be_nil
      expect(warehouse.grid[2][3]).to eq crate
      expect(warehouse.grid[2][4]).to be_nil
      expect(warehouse.grid[3][3]).to eq crate
      expect(warehouse.grid[3][4]).to be_nil
      expect(warehouse.grid[4][3]).to be_nil
    end

    it 'does not store crate if one is already present at the same position' do
      position = Position.new(2, 2)
      crate_1 = Crate.new(2, 2, 'A')
      crate_2 = crate_1.dup

      warehouse.store(crate_1, position)

      expect do
        warehouse.store(crate_2, position)
      end.to raise_error(WarehouseGrid::PositionOccupied)
    end

    it 'does not store crate if it would overlap with another' do
      position_1 = Position.new(2, 2)
      crate_1 = Crate.new(2, 2, 'A')
      warehouse.store(crate_1, position_1)

      position_2 = Position.new(3, 3)
      crate_2 = Crate.new(1, 1, 'B')

      expect do
        warehouse.store(crate_2, position_2)
      end.to raise_error(WarehouseGrid::PositionOccupied)
    end
  end

  describe '#positions_with_product_code' do
    before(:each) do
      crate_1 = Crate.new(1, 1, 'A')
      crate_2 = Crate.new(1, 1, 'A')
      crate_3 = Crate.new(1, 1, 'B')
      crate_4 = Crate.new(2, 2, 'C')

      warehouse.store(crate_1, Position.new(0, 0))
      warehouse.store(crate_2, Position.new(4, 4))
      warehouse.store(crate_3, Position.new(0, 3))
      warehouse.store(crate_4, Position.new(2, 2))
    end

    it 'returns a set' do
      expect(warehouse.positions_with_product_code('Z')).to be_a(Set)
    end

    it 'shows a list of positions where product code A can be found' do
      expected = [Position.new(0, 0), Position.new(4, 4)]

      expect(warehouse.positions_with_product_code('A').to_a).to match_array(expected)
    end

    it 'shows a list of positions where product code C can be found' do
      expected = [Position.new(2, 2)]

      expect(warehouse.positions_with_product_code('C').to_a).to match_array(expected)
    end
  end
end
