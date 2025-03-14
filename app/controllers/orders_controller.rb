class OrdersController < ApplicationController
  include Common

  def my_orders
    @orders = SnfCore::Order.where(user_id: current_user.id)
    @order_items = SnfCore::OrderItem.includes(store_inventory: :product)
                                 .where(order_id: @orders.pluck(:id))

    order_items_with_products = @order_items.map do |item|
      {
        id: item.id,
        order_id: item.order_id,
        quantity: item.quantity,
        unit_price: item.unit_price,
        product: item.store_inventory&.product,
        store_inventory: item.store_inventory
      }
    end

    render json: {
      success: true,
      orders: @orders,
      order_items: order_items_with_products
    }
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
