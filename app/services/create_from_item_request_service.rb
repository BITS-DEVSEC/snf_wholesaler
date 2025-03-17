class CreateFromItemRequestService
  def initialize(item_request_id:, current_user:, price: nil, notes:, seller_id:)
    @item_request_id = item_request_id
    @current_user = current_user
    @price = price
    @notes = notes
    @seller_id = seller_id
  end

  def call
    item_request = SnfCore::ItemRequest.find(item_request_id)

    SnfCore::Quotation.create!(
      item_request: item_request,
      price: @price,
      delivery_date: item_request.requested_delivery_date,
      valid_until: Date.current + 7.days,
      status: "pending",
      notes: @notes,
      user_id: @seller_id
    )
  end

  private

  attr_reader :item_request_id, :current_user, :price, :notes, :seller_id
end
