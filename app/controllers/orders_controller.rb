class OrdersController < ApplicationController
  include Common

  def my_orders
    @orders = SnfCore::Order.where(user_id: current_user.id)
    @order_items = SnfCore::OrderItem.where(order_id: @orders.pluck(:id))
    render json: { success: true, orders: @orders, order_items: @order_items }
  end

  def create_from_quotation
    order = CreateFromQuotationService.new(
      quotation_id: params[:quotation_id],
      current_user: current_user
    ).call
    render json: { success: true, data: order }, status: :created
  rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def model_params
    params.require(:payload).permit(
      :user_id,
      :store_id,
      :status,
      :total_amount,
      :quotation_id
    )
  end
end
