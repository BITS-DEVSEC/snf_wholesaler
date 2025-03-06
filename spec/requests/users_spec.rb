require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:valid_attributes) do
    {
      first_name: Faker::Name.first_name,
      middle_name: Faker::Name.middle_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      phone_number: Faker::PhoneNumber.phone_number,
      password_digest: Faker::Internet.password,
      reset_password_token: Faker::Internet.password
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

  it_behaves_like "request_shared_spec", "users", 11
end
