class OrdersController < ApplicationController
  include Common

  def my_orders
    @orders = SnfCore::Order.where(user_id: current_user.id)
    render json: { success: true, orders: @orders }
  end

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
