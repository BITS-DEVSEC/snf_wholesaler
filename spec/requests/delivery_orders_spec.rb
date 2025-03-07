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

  it_behaves_like "request_shared_spec", "delivery_orders", 10, []

end
