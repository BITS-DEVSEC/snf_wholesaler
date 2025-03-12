class UsersController < ApplicationController
  include Common

  def create
    render json: { error: "User creation not allowed through this endpoint" }, status: :forbidden
  end

  def update
    render json: { error: "User updates not allowed through this endpoint" }, status: :forbidden
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
      :reset_password_token
    )
  end
end
