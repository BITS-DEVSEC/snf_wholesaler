class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :sku,
             :name,
             :description,
             :base_price,
             :category_id,
             :created_at

  belongs_to :category
end
