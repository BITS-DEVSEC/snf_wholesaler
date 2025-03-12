class BusinessSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :business_name, :tin_number, :business_type,
             :verification_status, :verified_at, :created_at, :updated_at

  belongs_to :user
end
