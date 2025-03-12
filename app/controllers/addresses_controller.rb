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
            :house_number,
            :longitude
        )
    end
end
