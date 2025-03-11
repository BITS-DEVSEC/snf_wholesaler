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
      address: create(:address)
    }
  end

  let(:invalid_attributes) do
    {
      first_name: nil,
      middle_name: nil,
      last_name: nil,
      phone_number: nil,
      date_of_birth: nil,
      nationality: nil
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

  it_behaves_like "request_shared_spec", "users", 20
end
