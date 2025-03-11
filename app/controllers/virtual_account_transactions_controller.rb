class VirtualAccountTransactionsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(
      :from_account_id,
      :to_account_id,
      :amount,
      :transaction_type,
      :status,
      :reference_number,
      :description
    )
  end
end
