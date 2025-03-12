class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :store_inventory_id, :quantity, :unit_price,
             :subtotal, :created_at, :updated_at

  belongs_to :order
  belongs_to :store_inventory
end
