class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :store_id, :status, :total_amount,
             :created_at, :updated_at

  belongs_to :user
  belongs_to :store
end
