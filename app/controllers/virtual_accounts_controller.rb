class VirtualAccountsController < ApplicationController
  include Common

  def my_virtual_account
    virtual_account = SnfCore::VirtualAccount.find_by(user_id: current_user.id)
    if virtual_account
      render json: { success: true, data: virtual_account }, status: :ok
    else
      render json: { success: false, error: "Virtual account not found" }, status: :not_found
    end
  end

  private

  def model_params
    params.require(:payload).permit(
      :user_id,
      :branch_code,
      :product_scheme,
      :voucher_type,
      :balance,
      :interest_rate,
      :interest_type,
      :active,
      :cbs_account_number,
      :status
    )
  end
end
