require 'rails_helper'

RSpec.describe "StoreInventories", type: :request do
  let(:valid_attributes) do
    {
      store_id: create(:store).id,
      product_id: create(:product).id,
      base_price: Faker::Commerce.price,
      status: 0
    }
  end

  let(:invalid_attributes) do
    {
      store_id: nil,
      product_id: nil,
      base_price: nil,
      status: nil
    }
  end

  let(:new_attributes) do
    {
      base_price: Faker::Commerce.price,
      status: 1
    }
  end

  it_behaves_like "request_shared_spec", "store_inventories", 9
end
