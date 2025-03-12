require 'rails_helper'

RSpec.describe "Quotations", type: :request do
  let(:valid_attributes) do
    {
      item_request_id: create(:item_request).id,
      price: Faker::Commerce.price,
      delivery_date: Date.today.advance(days: 25),
      valid_until: Date.today.advance(days: 20),
      status: "pending",
      notes: Faker::Lorem.sentence
    }
  end

  let(:invalid_attributes) do
    {
      item_request_id: nil,
      price: Faker::Commerce.price,
      delivery_date: Date.today.advance(days: 25),
      valid_until: Date.today.advance(days: 20),
      status: "pending",
      notes: Faker::Lorem.sentence
    }
  end

  let(:new_attributes) do
    {
      notes: Faker::Lorem.sentence
    }
  end

  it_behaves_like "request_shared_spec", "quotations", 7
end
