class CustomerGroupsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :discount_code,
      :expire_date,
      :is_used,
      :group_id,
      :customer_id
    )
  end
end
