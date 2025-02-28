class ProductsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :sku,
      :name,
      :description,
      :base_price,
      :category_id,
      :thumbnail_image,
      images: []
    )
  end
end
