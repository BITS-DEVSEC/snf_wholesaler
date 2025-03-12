class QuotationsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(:item_request_id, :price, :delivery_date, :valid_until, :status, :notes)
  end
end
