require 'rails_helper'

RSpec.describe "Orders", type: :request do
  let(:store_inventory) { create(:store_inventory) }
  
  let(:valid_attributes) do
    {
      user_id: create(:user, role: :retailer).id,
      store_id: create(:store).id,
      status: :pending,
      total_amount: 1000.0,
      order_items_attributes: [
        {
          store_inventory_id: store_inventory.id,
          quantity: 5,
          unit_price: 200.0,
          subtotal: 1000.0
        }
      ]
    }
  end

  let(:invalid_attributes) do
    {
      user_id: nil,
      store_id: nil,
      status: nil,
      total_amount: nil
    }
  end

  it_behaves_like "request_shared_spec", "orders", 7, [:update, :create]

  describe "POST /create" do
    context "with valid params" do
      it "creates a new order" do
        expect {
          post orders_url,
               params: {
                 payload: valid_attributes
               }
        }.to change(SnfCore::Order, :count).by(1)
      end

      it "creates associated order items" do
        expect {
          post orders_url,
               params: {
                 payload: valid_attributes
               }
        }.to change(SnfCore::OrderItem, :count).by(1)
      end
    end
  end

  describe "PUT /update" do
    context "with valid params" do
      it "updates the requested order" do
        order = SnfCore::Order.create! valid_attributes
        put order_url(order),
            params: { payload: { status: :confirmed } }
        order.reload
        expect(order.status).to eq("confirmed")
      end
    end
  end
end