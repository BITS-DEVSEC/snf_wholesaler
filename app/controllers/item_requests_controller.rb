class ItemRequestsController < ApplicationController
  include Common

  # Override the index method to exclude the current user's requests
  def index
    if current_user
      @records = SnfCore::ItemRequest.where.not(user_id: current_user.id)
    else
      @records = SnfCore::ItemRequest.all
    end
    
    total = @records.count
    @records = @records.then(&paginate) if params[:page]
    
    result = {
      success: true,
      data: serialize(@records)
    }
    
    if params[:page]
      result[:page] = params[:page]
      result[:total] = total
    end

    render json: result
  end

  private

  def model_params
    params.require(:payload).permit(
      :user_id,
      :product_id,
      :quantity,
      :status,
      :unit,
      :requested_delivery_date,
      :notes
    )
  end
end
