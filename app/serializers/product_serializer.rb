class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :sku,
             :name,
             :description,
             :category_id,
             :base_price,
             :thumbnail_url,
             :image_urls

  belongs_to :category

  def thumbnail_url
    rails_blob_url(object.thumbnail_image, only_path: true) if object.thumbnail_image.attached?
  end

  def image_urls
    object.images.map { |image| rails_blob_url(image, only_path: true) } if object.images.attached?
  end
end
