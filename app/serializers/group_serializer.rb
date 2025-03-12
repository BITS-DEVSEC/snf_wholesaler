class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :business_id, :created_at, :updated_at

  belongs_to :business
end
