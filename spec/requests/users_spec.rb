require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:valid_attributes) do
    {
      first_name: Faker::Name.first_name,
      middle_name: Faker::Name.middle_name,
      last_name: Faker::Name.last_name,
      password: Faker::Internet.password,
      password_changed: false,
      reset_password_token: Faker::Internet.password,
      email: Faker::Internet.email,
      phone_number: Faker::Alphanumeric.alpha(number: 10),
      kyc_status: :pending,
      nationality: Faker::Address.country,
      occupation: Faker::Job.title,
      source_of_funds: Faker::Lorem.word,
      gender: "male",
      date_of_birth: Date.today,
      verified_by_id: nil,
      verified_at: DateTime.now,
      address_id: create(:address).id
    }
  end

  let(:invalid_attributes) do
    {
      first_name: nil,
      middle_name: nil,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      phone_number: Faker::PhoneNumber.phone_number
    }
  end

  let(:new_attributes) do
    {
      first_name: Faker::Name.first_name,
      middle_name: Faker::Name.middle_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      phone_number: Faker::PhoneNumber.phone_number
    }
  end

  it_behaves_like "request_shared_spec", "users", 15, %i[create update]

  describe "POST /users/:id/update_kyc_status" do
    let(:target_user) { create(:user, kyc_status: :pending) }

    context "when updating kyc status" do
      it "updates to approved status" do
        post update_kyc_status_user_path(target_user), params: { kyc_status: 'approved' }

        expect(response).to have_http_status(:success)
        result = JSON(response.body)
        expect(result['success']).to be true

        target_user.reload
        expect(target_user.kyc_status).to eq('approved')
        expect(target_user.verified_at).to be_present
      end

      it "updates to rejected status" do
        post update_kyc_status_user_path(target_user), params: { kyc_status: 'rejected' }

        expect(response).to have_http_status(:success)
        target_user.reload
        expect(target_user.kyc_status).to eq('rejected')
      end
    end

    context "with invalid parameters" do
      it "requires kyc_status parameter" do
        post update_kyc_status_user_path(target_user), params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        result = JSON(response.body)
        expect(result['error']).to eq('KYC status is required')
      end
    end
  end
end
