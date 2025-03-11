class OrdersController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :user_id,
      :store_id,
      :status,
      :total_amount
    )
  end
end
