require 'rails_helper'

RSpec.describe "VirtualAccounts", type: :request do
  let(:user) { create(:user) }

  let(:valid_attributes) do
    {
      user_id: user.id,
      branch_code: "001",
      product_scheme: "1",
      voucher_type: "0",
      balance: 1000,
      interest_rate: 0.09,
      interest_type: "conventional",
      active: true,
      cbs_account_number: "CBS#{SecureRandom.hex(8)}"
    }
  end

  let(:invalid_attributes) do
    {
      user_id: nil,
      branch_code: nil,
      product_scheme: nil,
      voucher_type: nil,
      balance: nil,
      interest_rate: nil,
      interest_type: nil,
      cbs_account_number: nil
    }
  end

  let(:new_attributes) do
    {
      user_id: user.id,
      branch_code: "001",
      product_scheme: "1",
      voucher_type: "0",
      balance: 1000,
      interest_rate: 0.09,
      interest_type: "conventional",
      active: true,
      cbs_account_number: "CBS#{SecureRandom.hex(8)}"
    }
  end

  it_behaves_like "request_shared_spec", "virtual_accounts", 11, []

  describe "with different interest types" do
    it "creates an interest-free account" do
      params = {
        payload: valid_attributes.merge(
          interest_type: "interest_free",
          interest_rate: 0.0
        )
      }

      post virtual_accounts_url, params: params, as: :json
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["data"]["interest_type"]).to eq("interest_free")
    end

    it "creates a preferential account" do
      params = {
        payload: valid_attributes.merge(
          interest_type: "preferential",
          interest_rate: 0.15
        )
      }

      post virtual_accounts_url, params: params, as: :json
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["data"]["interest_rate"]).to eq("0.15")
    end
  end

  describe "GET /virtual_accounts/my_virtual_account" do
    let(:user) { create(:user) }


    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    context "when user has a virtual account" do
      it "returns the virtual account" do
        virtual_account = create(:virtual_account, user: user)

        get "/virtual_accounts/my_virtual_account"

        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body)
        expect(result['success']).to be true
        expect(result['data']['id']).to eq(virtual_account.id)
        expect(result['data']['user_id']).to eq(user.id)
      end
    end

    context "when user does not have a virtual account" do
      it "returns not found status" do
        get "/virtual_accounts/my_virtual_account"

        expect(response).to have_http_status(:not_found)
        result = JSON.parse(response.body)
        expect(result['success']).to be false
        expect(result['error']).to eq("Virtual account not found")
      end
    end
  end
end
