class BusinessDocumentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :business_id,
             :document_type,
             :uploaded_at

  belongs_to :business
  belongs_to :verified_by

  def document_url
    rails_blob_url(object.document, only_path: true) if object.document.attached?
  end
end