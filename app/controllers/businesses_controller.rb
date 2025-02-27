class BusinessesController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :user_id,
      :business_name,
      :tin_number,
      :business_type,
      :verification_status
    )
  end
end
