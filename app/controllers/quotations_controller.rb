class QuotationsController < ApplicationController
  include Common

  def my_quotations
    item_requests = SnfCore::ItemRequest.includes(:product)
                                    .where(user_id: current_user.id)
    quotations = SnfCore::Quotation.includes(:item_request)
                                .where(item_request_id: item_requests.ids)

    quotations_with_details = quotations.map do |quotation|
      {
        id: quotation.id,
        price: quotation.price,
        delivery_date: quotation.delivery_date,
        valid_until: quotation.valid_until,
        status: quotation.status,
        notes: quotation.notes,
        phone_number: current_user.phone_number,
        item_request: {
          id: quotation.item_request.id,
          quantity: quotation.item_request.quantity,
          status: quotation.item_request.status,
          product: quotation.item_request.product
        }
      }
    end

    render json: { success: true, data: quotations_with_details }, status: :ok
  end

  def seller_quotations
    quotations = SnfCore::Quotation.includes(:item_request)
                                .where(user_id: current_user.id)

    if quotations.empty?
      return render json: { success: true, message: "No quotations found", data: [] }, status: :ok
    end

    quotations_with_details = quotations.map do |quotation|
      {
        id: quotation.id,
        price: quotation.price,
        delivery_date: quotation.delivery_date,
        valid_until: quotation.valid_until,
        status: quotation.status,
        notes: quotation.notes,
        phone_number: quotation.item_request.user.phone_number,
        item_request: {
          id: quotation.item_request.id,
          quantity: quotation.item_request.quantity,
          status: quotation.item_request.status,
          product: quotation.item_request.product
        }
      }
    end

    render json: { success: true, data: quotations_with_details }, status: :ok
  end

  def create_from_item_request
    quotation = CreateFromItemRequestService.new(
      item_request_id: params[:item_request_id],
      price: params[:price],
      notes: params[:notes],
      seller_id: params[:seller_id],
      current_user: current_user
    ).call
    render json: { success: true, data: quotation }, status: :created
  rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def model_params
    params.require(:payload).permit(
      :item_request_id,
      :user_id,
      :price,
      :delivery_date,
      :valid_until,
      :status,
      :notes
    )
  end
end
