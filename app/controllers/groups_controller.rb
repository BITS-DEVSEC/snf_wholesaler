class GroupsController < ApplicationController
  include Common

    private

    def model_params
      params.require(:payload).permit(
        :name,
        :business_id
      )
    end
end
