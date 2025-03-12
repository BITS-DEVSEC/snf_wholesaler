class AddressSerializer < ActiveModel::Serializer
  attributes :id, :address_type, :city, :sub_city, :woreda, :latitude,
             :longitude, :created_at, :updated_at
end
