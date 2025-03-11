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

  def top_wholesalers
    @product = Product.find(params[:id])
    user_latitude = params[:latitude]&.to_f
    user_longitude = params[:longitude]&.to_f

    @wholesalers = @product.store_inventories
      .includes(:store)
      .joins(:store)
      .where(status: :active)
      .select(
        "store_inventories.*",
        "stores.*",
        "(6371 * acos(cos(radians(?)) * cos(radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin(radians(latitude)))) AS distance",
      )
      .order(base_price: :asc)
      .order("distance ASC")
      .limit(3)
      .exec_query([ user_latitude, user_longitude, user_latitude ])

    render json: {
      data: @wholesalers.map { |inventory|
        {
          id: inventory.store.id,
          name: inventory.store.name,
          price: inventory.base_price,
          distance: inventory.distance.round(2),
          latitude: inventory.store.latitude,
          longitude: inventory.store.longitude
        }
      }
    }
  end

  def wholesalers
    product_ids = params.dig(:payload, :product_ids)

    if product_ids.blank?
      render json: { error: "product_ids parameter is required" }, status: :bad_request
      return
    end

    service = WholesalerFinderService.new(product_ids)
    wholesalers = service.find_best_wholesalers

    render json: { data: wholesalers }
  end

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
