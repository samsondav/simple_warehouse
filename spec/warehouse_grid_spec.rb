# frozen_string_literal: true

require 'spec_helper'

RSpec.describe WarehouseGrid do
  let(:empty_warehouse) do
    described_class.new(5, 5)
  end

  let(:populated_warehouse) do
    warehouse = described_class.new(5, 5)

    crate_1 = Crate.new(1, 1, 'A')
    crate_2 = Crate.new(1, 1, 'A')
    crate_3 = Crate.new(1, 1, 'B')
    crate_4 = Crate.new(2, 2, 'C')
    crate_5 = Crate.new(1, 1, 'D')

    warehouse.store(crate_1, Position.new(0, 0))
    warehouse.store(crate_2, Position.new(4, 4))
    warehouse.store(crate_3, Position.new(0, 3))
    warehouse.store(crate_4, Position.new(2, 2))
    warehouse.store(crate_5, Position.new(3, 4))

    warehouse
  end

  describe '#store' do
    let(:warehouse) { empty_warehouse }

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

    it 'stores a crate of product code at 2, 2' do
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

    it 'stores a crate at 0, 4' do
      position = Position.new(0, 4)
      crate = Crate.new(1, 1, 'A')

      warehouse.store(crate, position)

      expect(warehouse.grid[0][0]).to be_nil
      expect(warehouse.grid[0][1]).to be_nil
      expect(warehouse.grid[0][2]).to be_nil
      expect(warehouse.grid[0][3]).to be_nil
      expect(warehouse.grid[0][4]).to eq crate
      expect(warehouse.grid[1][0]).to be_nil
      expect(warehouse.grid[1][1]).to be_nil
      expect(warehouse.grid[1][2]).to be_nil
      expect(warehouse.grid[1][3]).to be_nil
      expect(warehouse.grid[1][4]).to be_nil
      expect(warehouse.grid[2][0]).to be_nil
      expect(warehouse.grid[2][1]).to be_nil
      expect(warehouse.grid[2][2]).to be_nil
      expect(warehouse.grid[2][3]).to be_nil
      expect(warehouse.grid[2][4]).to be_nil
      expect(warehouse.grid[3][0]).to be_nil
      expect(warehouse.grid[3][1]).to be_nil
      expect(warehouse.grid[3][2]).to be_nil
      expect(warehouse.grid[3][3]).to be_nil
      expect(warehouse.grid[3][4]).to be_nil
      expect(warehouse.grid[4][0]).to be_nil
      expect(warehouse.grid[4][1]).to be_nil
      expect(warehouse.grid[4][2]).to be_nil
      expect(warehouse.grid[4][3]).to be_nil
      expect(warehouse.grid[4][4]).to be_nil
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

  describe '#locate' do
    let(:warehouse) { populated_warehouse }

    it 'returns a set' do
      expect(warehouse.locate('Z')).to be_a(Set)
    end

    it 'shows a list of positions where product code A can be found' do
      expected = [Position.new(0, 0), Position.new(4, 4)]

      expect(warehouse.locate('A').to_a).to match_array(expected)
    end

    it 'shows a list of positions where product code C can be found' do
      expected = [Position.new(2, 2)]

      expect(warehouse.locate('C').to_a).to match_array(expected)
    end
  end

  describe '#remove' do
    let(:warehouse) { populated_warehouse }

    it 'raises out of bounds if x value is outside grid' do
      position = Position.new(10, 2)

      expect { warehouse.remove(position) }.to raise_error(WarehouseGrid::OutOfBounds)
    end

    it 'raises out of bounds if y value is outside grid' do
      position = Position.new(2, 10)

      expect { warehouse.remove(position) }.to raise_error(WarehouseGrid::OutOfBounds)
    end

    it 'returns a crate' do
      expect(warehouse.remove(Position.new(0, 0))).to be_a(Crate)
    end

    it 'removes a 1x1 crate' do
      warehouse.remove(Position.new(0, 0))

      expect(warehouse.grid[0][0]).to be_nil
    end

    it 'removes a 2x2 crate' do
      warehouse.remove(Position.new(2, 2))

      expect(warehouse.grid[2][2]).to be_nil
      expect(warehouse.grid[2][3]).to be_nil
      expect(warehouse.grid[3][2]).to be_nil
      expect(warehouse.grid[3][3]).to be_nil
    end

    it 'raises error if there is no crate to remove' do
      expect do
        warehouse.remove(Position.new(1, 0))
      end.to raise_error(WarehouseGrid::NoCrateHere)
    end
  end

  describe '#view' do
    it 'renders empty warehouse' do
      expect(empty_warehouse.view).to eq(<<~WAREHOUSE)
        _____
        _____
        _____
        _____
        _____
      WAREHOUSE
    end

    it 'renders warehouse with one crate' do
      position = Position.new(0, 4)
      crate = Crate.new(1, 1, 'A')

      empty_warehouse.store(crate, position)

      expect(empty_warehouse.view).to eq(<<~WAREHOUSE)
        A____
        _____
        _____
        _____
        _____
      WAREHOUSE
    end

    it 'renders warehouse with crates' do
      expect(populated_warehouse.view).to eq(<<~WAREHOUSE)
        ___DA
        B_CC_
        __CC_
        _____
        A____
      WAREHOUSE
    end
  end
end
