require 'rails_helper'

RSpec.describe CreateFromQuotationService do
  describe '#call' do
    before do
      @user = create(:user)
      @product = create(:product)
      @store = create(:store)
      @store_inventory = create(:store_inventory, store: @store, product: @product)
      @item_request = create(:item_request, user: @user, product: @product, quantity: 5)
      @quotation = create(:quotation, item_request: @item_request, price: 100)
    end

    it 'creates an order from quotation' do
      service = described_class.new(quotation_id: @quotation.id, current_user: @user)
      order = service.call

      expect(order).to be_persisted
      expect(order.user_id).to eq(@user.id)
      expect(order.store_id).to eq(@store.id)
      expect(order.total_amount).to eq(500)
      expect(order.order_items.count).to eq(1)

      order_item = order.order_items.first
      expect(order_item.quantity).to eq(5)
      expect(order_item.unit_price).to eq(100)
      expect(order_item.subtotal).to eq(500)
    end
  end
end
