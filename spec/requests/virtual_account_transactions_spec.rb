require 'rails_helper'

RSpec.describe "VirtualAccountTransactions", type: :request do
  let(:valid_attributes) do
    {
      from_account_id: create(:virtual_account).id,
      to_account_id: create(:virtual_account).id,
      amount: 1000.0,
      transaction_type: :transfer,
      status: :pending,
      reference_number: "TRX#{Time.current.to_i}",
      description: "Fund transfer between virtual accounts"
    }
  end

  let(:invalid_attributes) do
    {
      from_account_id: nil,
      to_account_id: nil,
      amount: nil,
      transaction_type: nil,
      status: nil,
      reference_number: nil
    }
  end

  let(:new_attributes) do
    {
      status: "completed",
      description: "Updated transaction description"
    }
  end

  it_behaves_like "request_shared_spec", "virtual_account_transactions", 10

  describe "POST /pay" do
    let(:order) { create(:order) }
    let(:buyer) { create(:user) }
    let(:seller) { create(:user) }
    let(:buyer_account) { create(:virtual_account, user: buyer) }
    let(:seller_account) { create(:virtual_account, user: seller) }
    let(:store) { create(:store, business: create(:business, user: seller)) }

    before do
      order.update(user: buyer, store: store)
    end

    context "with valid order number" do
      it "creates a new transaction" do
        params = {
          payload: {
            order_number: order.order_number
          }
        }

        expect {
          post pay_virtual_account_transactions_url,
               params: params,
               as: :json
        }.to change(SnfCore::VirtualAccountTransaction, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["data"]).to include(
          "from_account_id" => buyer_account.id,
          "to_account_id" => seller_account.id,
          "amount" => order.total_amount.to_s,
          "status" => "pending"
        )
      end
    end

    context "with invalid order number" do
      it "returns not found status" do
        params = {
          payload: {
            order_number: "INVALID-ORDER"
          }
        }

        post pay_virtual_account_transactions_url,
             params: params,
             as: :json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Order not found")
      end
    end
  end
end
