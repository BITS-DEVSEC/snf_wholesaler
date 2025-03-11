require 'rails_helper'

RSpec.describe "Addresses", type: :request do
  let(:valid_attributes) do
    {
      address_type: 'business',
      city: 'Addis Ababa',
      sub_city: 'Bole',
      woreda: '03',
      latitude: 9.0320,
      longitude: 38.7520
    }
  end

  let(:new_attributes) do
    {
      address_type: 'store1',
      city: 'Addis Ababa',
      sub_city: 'Yeka',
      woreda: '05',
      latitude: 9.0330,
      longitude: 38.7530
    }
  end

  let(:invalid_attributes) do
    {
      address_type: nil,
      city: nil,
      sub_city: nil
    }
  end

  it_behaves_like 'request_shared_spec', 'addresses', 10
end
