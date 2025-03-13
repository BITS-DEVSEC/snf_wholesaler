class UsersController < ApplicationController
  include Common

  def create
    render json: { error: "User creation not allowed through this endpoint" }, status: :forbidden
  end

  def update
    render json: { error: "User updates not allowed through this endpoint" }, status: :forbidden
  end

  def update_kyc_status
    return render json: { success: false, error: "KYC status is required" },
                status: :unprocessable_entity unless params[:kyc_status].present?

    user = SnfCore::User.find(params[:id])

    if user.update(
      kyc_status: params[:kyc_status],
      verified_at: Time.current
    )
      render json: { success: true, data: user }
    else
      render json: { success: false, errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

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
      :kyc_status
    )
  end
end
