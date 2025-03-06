class DeliveryOrdersController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :order_id,
      :delivery_model_id,
      :status,
      :pickup_time,
      :delivery_time,
      :pickup_location,
      :delivery_location,
      :notes,
      :driver_id
    )
  end
end
