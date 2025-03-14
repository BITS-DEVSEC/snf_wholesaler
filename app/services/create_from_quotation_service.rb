class CreateFromQuotationService
  def initialize(quotation_id:, current_user:)
    @quotation_id = quotation_id
    @current_user = current_user
  end

  def call
    quotation = SnfCore::Quotation.find(quotation_id)
    item_request = SnfCore::ItemRequest.find(quotation.item_request_id)
    store_inventory = SnfCore::StoreInventory.find_by!(product_id: item_request.product_id)

    ActiveRecord::Base.transaction do
      order = SnfCore::Order.create!(
        user_id: current_user.id,
        store_id: store_inventory.store_id,
        status: "pending",
        total_amount: quotation.price * item_request.quantity
      )

      SnfCore::OrderItem.create!(
        order_id: order.id,
        store_inventory_id: store_inventory.id,
        quantity: item_request.quantity,
        unit_price: quotation.price,
        subtotal: quotation.price * item_request.quantity
      )

      order
    end
  end

  private

  attr_reader :quotation_id, :current_user
end
