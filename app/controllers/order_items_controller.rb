class OrderItemsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :order_id,
      :store_inventory_id,
      :quantity,
      :unit_price,
      :subtotal
    )
  end
end
