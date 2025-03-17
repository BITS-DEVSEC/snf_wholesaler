require 'rails_helper'

RSpec.describe "Quotations", type: :request do
  let(:valid_attributes) do
    {
      item_request_id: create(:item_request).id,
      user_id: create(:user).id,
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


describe "POST /create_from_item_request" do
  let(:user) { create(:user) }
  let(:seller) { create(:user) }
  let(:product) { create(:product) }
  let(:item_request) { create(:item_request, user: user, product: product) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  context "with valid parameters" do
    it "creates a new quotation" do
      expect {
        post create_from_item_request_quotations_url,
             params: {
               item_request_id: item_request.id,
               price: 100.0,
               notes: "Test notes",
               seller_id: seller.id
             },
             as: :json
      }.to change(SnfCore::Quotation, :count).by(1)

      expect(response).to have_http_status(:created)
      result = JSON.parse(response.body)
      expect(result['success']).to be true
      expect(result['data']).to include(
        'item_request_id' => item_request.id,
        'price' => "100.0",
        'notes' => "Test notes",
        'user_id' => seller.id,
        'status' => "pending"
      )
    end
  end
end

describe "GET /seller_quotations" do
  let(:seller) { create(:user) }
  let(:buyer) { create(:user) }
  let(:product) { create(:product) }
  let(:item_request) { create(:item_request, user: buyer, product: product) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(seller)
  end

  context "when seller has quotations" do
    before do
      create(:quotation,
        item_request: item_request,
        user_id: seller.id,
        price: 100.0,
        notes: "Test notes",
        status: "pending"
      )
    end

    it "returns all quotations for the seller" do
      get "/quotations/seller_quotations"  # Changed to use route string

      expect(response).to have_http_status(:ok)
      result = JSON.parse(response.body)
      expect(result['success']).to be true
      expect(result['data'].length).to eq(1)

      quotation = result['data'].first
      expect(quotation).to include(
        'price' => "100.0",
        'status' => "pending",
        'notes' => "Test notes"
      )
      expect(quotation['item_request']).to include(
        'quantity' => item_request.quantity,
        'status' => item_request.status
      )
      expect(quotation['phone_number']).to eq(buyer.phone_number)
    end
  end

  context "when seller has no quotations" do
    it "returns an empty array with message" do
      get "/quotations/seller_quotations"

      expect(response).to have_http_status(:ok)
      result = JSON.parse(response.body)
      expect(result['success']).to be true
      expect(result['message']).to eq("No quotations found")
      expect(result['data']).to be_empty
    end
  end
end
end
