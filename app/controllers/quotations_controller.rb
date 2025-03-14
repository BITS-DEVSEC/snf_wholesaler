class QuotationsController < ApplicationController
  include Common

  def my_quotations
    item_request = SnfCore::ItemRequest.where(user_id: current_user.id)
    quotations = SnfCore::Quotation.where(item_request_id: item_request.ids)
    render json: { success: true, data: quotations }, status: :ok
  end

  def create_from_item_request
    quotation = CreateFromItemRequestService.new(
      item_request_id: params[:item_request_id],
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
      :price,
      :delivery_date,
      :valid_until,
      :status,
      :notes
    )
  end
end
