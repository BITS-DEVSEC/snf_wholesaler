class CustomerGroupSerializer < ActiveModel::Serializer
  attributes :id, :discount_code, :expire_date, :is_used, :group_id,
             :customer_id, :created_at, :updated_at

  belongs_to :group
  belongs_to :customer, class_name: "SnfCore::User"
end
