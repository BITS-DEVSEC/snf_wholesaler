class ItemRequestsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :user_id,
      :product_id,
      :quantity,
      :status,
      :unit,
      :requested_delivery_date,
      :notes
    )
  end
end
