class WalletsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :user_id,
      :wallet_number,
      :balance,
      :is_active
    )
  end
end
