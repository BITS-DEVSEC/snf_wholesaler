require 'rails_helper'

RSpec.describe "Orders", type: :request do
  let(:store_inventory) { create(:store_inventory, status: :available) }

  let(:valid_attributes) do
    retailer = create(:user)
    create(:user_role, user: retailer, role: create(:role, name: 'retailer'))

    {
      user_id: retailer.id,
      store_id: create(:store).id,
      status: :pending,
      total_amount: 1000.0,
      order_items_attributes: [ {
        store_inventory_id: store_inventory.id,
        quantity: 5,
        unit_price: 200.0,
        subtotal: 1000.0
      } ]
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

  let(:new_attributes) do
    {
      status: "pending"
    }
  end

  it_behaves_like "request_shared_spec", "orders", 9, []

  describe "GET /my_orders/" do
    let(:user) { create(:user) }
    let!(:user_orders) { create_list(:order, 3, user: user) }


    let!(:other_orders) { create_list(:order, 2) }

    before do
      allow_any_instance_of(OrdersController).to receive(:current_user).and_return(user)
    end

    it "returns only the current user's orders" do
      user_orders.each do |order|
        create(:order_item, order: order)
      end
      get "/orders/my_orders"

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(a_string_including("application/json"))

      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be true
      expect(json_response['orders'].length).to eq(3)
      expect(json_response['orders'].pluck('user_id')).to all(eq(user.id))
    end
  end
end
