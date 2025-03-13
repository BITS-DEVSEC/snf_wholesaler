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

  describe "GET /index" do
    it "does not return the current user's requests" do
      user = create(:user)

      # Mock the current_user instead of using token
      allow_any_instance_of(ItemRequestsController).to receive(:current_user).and_return(user)

      current_user_request = create(:item_request, user: user)
      other_user_request = create(:item_request, user: create(:user))

      get item_requests_url, as: :json

      json_response = JSON.parse(response.body)
      request_ids = json_response['data'].map { |req| req['id'].to_i }

      expect(request_ids).not_to include(current_user_request.id)
      expect(request_ids).to include(other_user_request.id)
    end
  end

  describe "GET /my_requests" do
    it "returns the current user's requests" do
      user = create(:user)
      allow_any_instance_of(ItemRequestsController).to receive(:current_user).and_return(user)

      my_request = create(:item_request, user: user)
      other_request = create(:item_request, user: create(:user))

      get my_requests_item_requests_url, as: :json

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response['success']).to be true
      expect(json_response['data'].length).to eq(1)
      expect(json_response['data'].first['id']).to eq(my_request.id)
      expect(json_response['data'].map { |req| req['id'] }).not_to include(other_request.id)
    end
  end
  it_behaves_like "request_shared_spec", "item_requests", 12
end
