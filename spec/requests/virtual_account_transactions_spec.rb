require 'rails_helper'

RSpec.describe "VirtualAccountTransactions", type: :request do
  let(:valid_attributes) do
    {
      from_account_id: create(:virtual_account).id,
      to_account_id: create(:virtual_account).id,
      amount: 1000.0,
      transaction_type: :transfer,
      reference_number: "TRX#{Time.current.to_i}"
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

  it_behaves_like "request_shared_spec", "virtual_account_transactions", 12

  describe "POST /pay" do
    let(:order) { create(:order, total_amount: 500.0) }
    let(:buyer) { create(:user) }
    let(:seller) { create(:user) }
    let(:buyer_account) { create(:virtual_account, user: buyer) }
    let(:seller_account) { create(:virtual_account, user: seller) }
    let(:store) { create(:store, business: create(:business, user: seller)) }

    before do
      order.update(user: buyer, store: store)
      buyer_account
      seller_account
    end

    context "with valid order id" do
      it "creates a new transaction" do
        category = create(:category)
        product = create(:product, category: category, base_price: 250.0)

        store_inventory = create(:store_inventory, store: store, product: product, base_price: 250.0)

        create(:order_item, order: order, store_inventory: store_inventory, quantity: 2, unit_price: 250.0, subtotal: 500.0)

        order.reload

        params = {
          payload: {
            order_id: order.id
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

    context "with invalid order id" do
      it "returns not found status" do
        params = {
          payload: {
            order_id: 0
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

  describe "GET /my_virtual_account_transactions" do
    let(:user) { create(:user) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    context "when user has a virtual account" do
      let(:virtual_account) { create(:virtual_account, user: user) }
      let(:other_account) { create(:virtual_account) }

      before do
        create(:virtual_account_transaction,
               from_account: virtual_account,
               to_account: other_account,
               amount: 100,
               transaction_type: :transfer,
               status: :completed)

        create(:virtual_account_transaction,
               from_account: other_account,
               to_account: virtual_account,
               amount: 200,
               transaction_type: :transfer,
               status: :completed)
      end

      it "returns all transactions involving user's account" do
        get my_virtual_account_transactions_virtual_account_transactions_path

        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body)
        debugger

        expect(result['success']).to be true
        expect(result['data'].length).to eq(2)

        transaction = result['data'].first
        expect(transaction).to include(
          'amount',
          'transaction_type',
          'status',
          'reference_number',
          'description',
          'from_account',
          'to_account'
        )
      end
    end

    context "when user does not have a virtual account" do
      it "returns not found status" do
        get my_virtual_account_transactions_virtual_account_transactions_path

        expect(response).to have_http_status(:not_found)
        result = JSON.parse(response.body)
        expect(result['success']).to be false
        expect(result['error']).to eq("Virtual account not found")
      end
    end
  end
end
