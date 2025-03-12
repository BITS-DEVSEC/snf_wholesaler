class DeliveryOrderSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :delivery_address, :contact_phone, :delivery_notes,
             :estimated_delivery_time, :actual_delivery_time, :status, :created_at, :updated_at

  belongs_to :order
end
