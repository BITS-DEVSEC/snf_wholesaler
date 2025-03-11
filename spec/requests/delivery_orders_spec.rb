require 'rails_helper'

RSpec.describe "DeliveryOrders", type: :request do
  let(:valid_attributes) do
    {
        order_id: create(:order).id,
        delivery_address: "Bole, Addis Ababa",
        contact_phone: "+251911234567",
        delivery_notes: "Please deliver during business hours",
        estimated_delivery_time: Time.current + 2.hours,
        actual_delivery_time: nil,
        status: 0
    }
  end

  let(:invalid_attributes) do
    {
        order_id: nil,
        delivery_address: nil,
        contact_phone: nil,
        delivery_notes: nil,
        estimated_delivery_time: nil,
        status: nil
    }
  end

  let(:new_attributes) do
    {
      status: "assigned"
    }
  end

  it_behaves_like "request_shared_spec", "delivery_orders", 10
end
