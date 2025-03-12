class QuotationSerializer < ActiveModel::Serializer
  attributes :id, :price, :delivery_date, :valid_until, :status, :notes
  belongs_to :item_request

end
