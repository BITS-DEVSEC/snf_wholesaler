class StoreSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :operational_status, :business_id,
             :address_id, :created_at, :updated_at

  belongs_to :business
  belongs_to :address
end
