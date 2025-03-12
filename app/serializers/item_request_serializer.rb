class ItemRequestSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :product_id, :quantity, :status,
             :requested_delivery_date, :notes, :created_at, :updated_at

  belongs_to :user
  belongs_to :product
end
