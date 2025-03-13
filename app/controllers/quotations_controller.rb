class QuotationsController < ApplicationController
  include Common

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
