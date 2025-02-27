class StoresController < ApplicationController
  include Common

    private

    def model_params
      params.require(:payload).permit(
        :name,
        :email,
        :operational_status,
        :business_id,
        :address_id
      )
    end
end
