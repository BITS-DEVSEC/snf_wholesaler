require 'rails_helper'

RSpec.describe "Businesses", type: :request do
  let(:valid_attributes) do
    {
      user_id: create(:user).id,
      business_name: "Test Business",
      tin_number: "1234567890",
      business_type: 0,
      verification_status: 0
    }
  end

  let(:invalid_attributes) do
    {
      user_id: nil,
      business_name: nil,
      tin_number: nil,
      business_type: nil,
      verification_status: nil
    }
  end

  let(:new_attributes) do
    {
      business_name: "Updated Business Name"
    }
  end

  it_behaves_like "request_shared_spec", "businesses", 9
end
