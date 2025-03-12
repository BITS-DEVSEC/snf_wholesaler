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

  it_behaves_like "request_shared_spec", "virtual_account_transactions", 12
end
