require 'rails_helper'

RSpec.describe "Wallets", type: :request do
  let(:valid_attributes) do
    {
      balance: 100.00,
      is_active: true
    }
  end

  let(:invalid_attributes) do
    {
      balance: nil,
      is_active: nil
    }
  end

  let(:new_attributes) do
    {
      balance: 200.00
    }
  end

  it_behaves_like "request_shared_spec", "wallets", 8, [ :create, :index ]
end
