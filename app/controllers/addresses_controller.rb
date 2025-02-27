class AddressesController < ApplicationController
    include Common

    private

    def model_params
        params.require(:payload).permit(
            :address_type,
            :city,
            :sub_city,
            :woreda,
            :latitude,
            :longitude
        )
    end
end
