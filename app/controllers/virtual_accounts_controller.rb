class VirtualAccountsController < ApplicationController
  include Common

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
