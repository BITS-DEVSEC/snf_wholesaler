class UsersController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :first_name,
      :middle_name,
      :last_name,
      :email,
      :phone_number,
      :password,
      :reset_password_token,
      :address_id,
      :date_of_birth,
      :nationality,
      :occupation,
      :source_of_funds,
      :kyc_status,
      :gender,
      :verified_at,
      :verified_by_id
    )
  end
end
