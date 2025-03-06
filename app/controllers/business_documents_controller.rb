class BusinessDocumentsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :business_id,
      :document_type,
      :uploaded_at,
      :document
    )
  end
end
