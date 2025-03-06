require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:valid_attributes) do
    {
      sku: Faker::Alphanumeric.alphanumeric(number: 10),
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph,
      base_price: Faker::Commerce.price,
      category_id: create(:category).id
    }
  end

  let(:invalid_attributes) do
    {
      sku: nil,
      name: nil,
      description: nil,
      base_price: nil,
      category_id: nil
    }
  end

  let(:new_attributes) do
    {
      sku: Faker::Alphanumeric.alphanumeric(number: 10),
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph,
      base_price: Faker::Commerce.price,
      category_id: create(:category).id
    }
  end

  it_behaves_like 'request_shared_spec', 'products', 8

end
