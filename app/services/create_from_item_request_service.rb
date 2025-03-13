class CreateFromItemRequestService
  def initialize(item_request_id:, current_user:)
    @item_request_id = item_request_id
    @current_user = current_user
  end

  def call
    item_request = SnfCore::ItemRequest.find(item_request_id)

    SnfCore::Quotation.create!(
      item_request: item_request,
      price: calculate_price(item_request),
      delivery_date: item_request.requested_delivery_date,
      valid_until: Date.current + 7.days,
      status: "pending"
    )
  end

  private

  attr_reader :item_request_id, :current_user

  def calculate_price(item_request)
    # Add your price calculation logic here
    item_request.quantity * 100 # Example placeholder price
  end
end
