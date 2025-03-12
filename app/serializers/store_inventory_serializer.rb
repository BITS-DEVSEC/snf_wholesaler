class StoreInventorySerializer < ActiveModel::Serializer
  attributes :id, :store_id, :product_id, :base_price, :status, :created_at, :updated_at

  belongs_to :store
  belongs_to :product
end
