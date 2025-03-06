require 'rails_helper'

RSpec.describe WholesalerFinderService do
  describe '#find_best_wholesalers' do
    let(:products) { create_list(:product, 3) }
    let(:store1) { create(:store, name: "Store 1") }
    let(:store2) { create(:store, name: "Store 2") }
    let(:store3) { create(:store, name: "Store 3") }

    context 'when some stores have all products' do
      before do
        # Store 1 has all products with lowest total price
        create(:store_inventory, store: store1, product: products[0], base_price: 100, status: 0)
        create(:store_inventory, store: store1, product: products[1], base_price: 90, status: 0)
        create(:store_inventory, store: store1, product: products[2], base_price: 95, status: 0)

        # Store 2 has all products with higher prices
        create(:store_inventory, store: store2, product: products[0], base_price: 110, status: 0)
        create(:store_inventory, store: store2, product: products[1], base_price: 100, status: 0)
        create(:store_inventory, store: store2, product: products[2], base_price: 105, status: 0)

        # Store 3 has only two products with lowest individual prices
        create(:store_inventory, store: store3, product: products[0], base_price: 80, status: 0)
        create(:store_inventory, store: store3, product: products[1], base_price: 85, status: 0)
      end

      it 'prioritizes stores with all products' do
        service = described_class.new(products.map(&:id))
        result = service.find_best_wholesalers

        expect(result.first[:name]).to eq("Store 1")
        expect(result.first[:coverage_percentage]).to eq(100.0)
        expect(result.first[:total_price]).to eq(285)
      end

      it 'includes partial matches after complete matches' do
        service = described_class.new(products.map(&:id))
        result = service.find_best_wholesalers

        expect(result.map { |r| r[:name] }).to eq(["Store 1", "Store 2", "Store 3"])
        expect(result.last[:coverage_percentage]).to eq(66.67)
      end
    end

    context 'when no store has all products' do
      before do
        # Store 1 has two products
        create(:store_inventory, store: store1, product: products[0], base_price: 100, status: 0)
        create(:store_inventory, store: store1, product: products[1], base_price: 90, status: 0)

        # Store 2 has one product
        create(:store_inventory, store: store2, product: products[0], base_price: 80, status: 0)

        # Store 3 has two different products
        create(:store_inventory, store: store3, product: products[1], base_price: 85, status: 0)
        create(:store_inventory, store: store3, product: products[2], base_price: 95, status: 0)
      end
    end

    context 'with invalid or empty input' do
      it 'returns empty array for empty product_ids' do
        service = described_class.new([])
        expect(service.find_best_wholesalers).to be_empty
      end

      it 'returns empty array when no active inventories found' do
        service = described_class.new(products.map(&:id))
        expect(service.find_best_wholesalers).to be_empty
      end
    end
  end
end
