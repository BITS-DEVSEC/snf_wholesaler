require 'rails_helper'

RSpec.describe "CustomerGroups", type: :request do
  let(:valid_attributes) do
      {
        discount_code: Faker::Alphanumeric.alpha(number: 10),
        expire_date: DateTime.tomorrow,
        is_used: false,
        group_id: create(:group).id,
        customer_id: create(:user).id
      }
    end

    let(:invalid_attributes) do
      {
        discount_code: Faker::Alphanumeric.alpha(number: 10),
        expire_date: DateTime.tomorrow,
        is_used: false,
        group_id: nil,
        customer_id: nil
      }
    end

    let(:new_attributes) do
      {
        discount_code: Faker::Alphanumeric.alpha(number: 10),
        expire_date: DateTime.tomorrow,
        is_used: false,
        group_id: create(:group).id,
        customer_id: create(:user).id
      }
    end

    it_behaves_like "request_shared_spec", "customer_groups", 10
end
