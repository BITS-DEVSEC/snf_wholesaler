require 'rails_helper'

RSpec.describe "Groups", type: :request do
  let(:valid_attributes) do
    {
      name: Faker::Name.first_name,
      business_id: create(:business).id
    }
  end

  let(:invalid_attributes) do
    {
      name: nil
    }
  end

  let(:new_attributes) do
    {
      name: Faker::Name.name,
      business_id: create(:business).id
    }
  end

  it_behaves_like "request_shared_spec", "groups", 6
end
