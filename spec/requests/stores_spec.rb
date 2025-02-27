require 'rails_helper'

RSpec.describe "Stores", type: :request do
  let(:valid_attributes) do
      {
        name: Faker::Name.name,
        email: Faker::Internet.email,
        operational_status: 1,
        business_id: create(:business).id,
        address_id: create(:address).id
      }
    end

    let(:invalid_attributes) do
      {
        name: nil,
        email: Faker::Internet.email,
        operational_status: 1,
        business_id: nil,
        address_id: create(:address).id
      }
    end

    let(:new_attributes) do
      {
        name: Faker::Name.name,
        email: Faker::Internet.email,
        operational_status: 1,
        business_id: create(:business).id,
        address_id: create(:address).id
      }
    end

    it_behaves_like "request_shared_spec", "stores", 8
end
