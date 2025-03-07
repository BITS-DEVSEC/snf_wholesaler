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
      order_items_attributes: [{
        store_inventory_id: store_inventory.id,
        quantity: 5,
        unit_price: 200.0,
        subtotal: 1000.0
      }]
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

  it_behaves_like "request_shared_spec", "orders", 7, []

end
