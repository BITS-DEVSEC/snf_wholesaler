require 'rails_helper'

RSpec.describe "DeliveryOrders", type: :request do
  let(:valid_attributes) do
    {
      order_id: create(:order).id,
      delivery_model_id: create(:delivery_model).id,
      status: :pending,
      pickup_time: Time.current,
      delivery_time: Time.current + 2.hours,
      pickup_location: "store A",
      delivery_location: "retailer B",
      driver_id: create(:user, role: :driver).id,
      notes: "Handle with care"
    }
  end

  let(:invalid_attributes) do
    {
      order_id: nil,
      delivery_model_id: nil,
      status: nil,
      pickup_time: nil,
      delivery_time: nil
    }
  end

  it_behaves_like "request_shared_spec", "delivery_orders", 9, [:update, :create]

  describe "POST /create" do
    context "with valid params" do
      it "creates a new delivery order" do
        expect {
          post delivery_orders_url,
               params: {
                 payload: valid_attributes
               }
        }.to change(SnfCore::DeliveryOrder, :count).by(1)
      end
    end
  end

  describe "PUT /update" do
    context "with valid params" do
      it "updates the requested delivery_order" do
        delivery_order = SnfCore::DeliveryOrder.create! valid_attributes
        put delivery_order_url(delivery_order),
            params: { payload: { status: :in_progress } }
        delivery_order.reload
        expect(delivery_order.status).to eq("in_progress")
      end
    end
  end
end
