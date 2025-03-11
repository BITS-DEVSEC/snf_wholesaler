require 'rails_helper'

RSpec.describe "ItemRequests", type: :request do
  let(:valid_attributes) do
    {
      user_id: create(:user).id,
      product_id: create(:product).id,
      quantity: 10,
      requested_delivery_date: Date.tomorrow,
      notes: "Urgent delivery needed",
      status: :pending
    }
  end

  let(:invalid_attributes) do
    {
      user_id: nil,
      product_id: nil,
      quantity: nil,
      requested_delivery_date: nil,
      status: nil
    }
  end

  let(:new_attributes) do
    {
      quantity: 20,
      requested_delivery_date: Date.tomorrow + 2.days,
      notes: "Updated delivery instructions",
      status: :approved
    }
  end

  it_behaves_like "request_shared_spec", "item_requests", 9
end
