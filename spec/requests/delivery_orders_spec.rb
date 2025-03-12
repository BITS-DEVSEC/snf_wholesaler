require 'rails_helper'

RSpec.describe "DeliveryOrders", type: :request do
  let(:valid_attributes) do
    {
      order_id: create(:order).id,
      status: :pending,
      pickup_time: Time.current,
      delivery_address: Faker::Address.street_name,
      estimated_delivery_time: Time.current + 1.hour,
      actual_delivery_time: Time.current + 2.hours,
      contact_phone: Faker::PhoneNumber.phone_number,
      delivery_notes: Faker::Lorem.sentence
    }
  end

  let(:invalid_attributes) do
    {
      order_id: nil,
      status: :pending,
      pickup_time: Time.current,
      delivery_address: Faker::Address.street_name,
      estimated_delivery_time: Time.current + 1.hour,
      actual_delivery_time: Time.current + 2.hours,
      contact_phone: Faker::PhoneNumber.phone_number,
      delivery_notes: Faker::Lorem.sentence
    }
  end

  let(:new_attributes) do
    {
      status: "assigned"
    }
  end

  it_behaves_like "request_shared_spec", "delivery_orders", 11
end
