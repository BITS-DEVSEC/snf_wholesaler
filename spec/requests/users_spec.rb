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

  describe "GET /users/:id/has_virtual_account" do
    let(:user) { create(:user) }

    context "when user has a virtual account" do
      it "returns true" do
        create(:virtual_account, user: user)

        get "/users/#{user.id}/has_virtual_account"

        expect(response).to be_successful
        result = JSON.parse(response.body)
        expect(result['success']).to be_truthy
        expect(result['has_virtual_account']).to be_truthy
      end
    end

    context "when user does not have a virtual account" do
      it "returns false" do
        get "/users/#{user.id}/has_virtual_account"

        expect(response).to be_successful
        result = JSON.parse(response.body)
        expect(result['success']).to be_truthy
        expect(result['has_virtual_account']).to be_falsey
      end
    end

    context "when user does not exist" do
      it "returns 404 not found" do
        get "/users/999999/has_virtual_account"

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /users/profile" do
    let(:user) { create(:user) }

    context "when user exists" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      it "returns user profile successfully" do
        get profile_users_path

        expect(response).to have_http_status(:success)
        result = JSON.parse(response.body)
        expect(result['success']).to be true
        expect(result['data']['id']).to eq(user.id)
      end
    end

    context "when user does not exist" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
      end

      it "returns not found error" do
        get profile_users_path

        expect(response).to have_http_status(:not_found)
        result = JSON.parse(response.body)
        expect(result['success']).to be false
        expect(result['error']).to eq('User not found')
      end
    end

    context "when an unexpected error occurs" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        allow(SnfCore::User).to receive(:find).and_raise(StandardError.new("Unexpected error"))
      end

      it "returns unprocessable entity error" do
        get profile_users_path

        expect(response).to have_http_status(:unprocessable_entity)
        result = JSON.parse(response.body)
        expect(result['success']).to be false
        expect(result['error']).to eq('Unexpected error')
      end
    end
  end
end
