class VirtualAccountTransactionsController < ApplicationController
  include Common

  after_action :update_order_status, only: [:update]

  def pay
    order = SnfCore::Order.find_by(order_number: params.dig(:payload, :order_number))
    return render json: { error: 'Order not found' }, status: :not_found unless order

    buyer_account = SnfCore::VirtualAccount.find_by(user_id: order.user_id)
    seller_account = SnfCore::VirtualAccount.find_by(user_id: order.store.business.user_id)

    return render json: { error: 'Virtual accounts not found' }, status: :not_found unless buyer_account && seller_account

    @record = SnfCore::VirtualAccountTransaction.create(
      from_account_id: buyer_account.id,
      to_account_id: seller_account.id,
      amount: order.total_amount,
      transaction_type: :payment,
      status: :pending,
      reference_number: "ORDER-#{order.id}",
      description: "Payment for order #{order.order_number}"
    )

    if @record.save
      render json: { data: @record }, status: :created
    else
      render json: { error: @record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def model_params
    params.require(:payload).permit(
      :from_account_id,
      :to_account_id,
      :amount,
      :transaction_type,
      :status,
      :reference_number,
      :description,
      :order_number
    )
  end

  def update_order_status
    return unless @record.completed? && @record.reference_number.present?

    order_id = @record.reference_number.split('-').last
    order = SnfCore::Order.find_by(id: order_id)
    
    return unless order

    order.update(status: :paid)
  end
end
