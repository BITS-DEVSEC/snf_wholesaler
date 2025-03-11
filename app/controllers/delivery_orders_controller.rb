class DeliveryOrdersController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :order_id,
      :delivery_address,
      :contact_phone,
      :delivery_notes,
      :estimated_delivery_time,
      :actual_delivery_time,
      :status
    )
  end
end
