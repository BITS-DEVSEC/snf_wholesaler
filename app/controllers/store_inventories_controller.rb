class StoreInventoriesController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :store_id,
      :product_id,
      :base_price,
      :status
    )
  end
end
