class VirtualAccountTransactionsController < ApplicationController
  include Common

  after_action :update_order_status, only: [ :pay ]

  def my_virtual_account_transactions
    virtual_account = SnfCore::VirtualAccount.find_by(user_id: current_user.id)
    return render json: { success: false, error: "Virtual account not found" }, status: :not_found unless virtual_account

    transactions = SnfCore::VirtualAccountTransaction
      .includes(:from_account, :to_account)
      .where("from_account_id = :id OR to_account_id = :id", id: virtual_account.id)
      .order(created_at: :desc)

    transactions_with_details = transactions.map do |transaction|
      {
        id: transaction.id,
        amount: transaction.amount,
        transaction_type: transaction.transaction_type,
        status: transaction.status,
        reference_number: transaction.reference_number,
        description: transaction.description,
        created_at: transaction.created_at,
        from_account: transaction.from_account.slice(:id, :branch_code, :cbs_account_number),
        to_account: transaction.to_account.slice(:id, :branch_code, :cbs_account_number)
      }
    end

    render json: { success: true, data: transactions_with_details }, status: :ok
  end

  def pay
    order = SnfCore::Order.find_by(id: params.dig(:payload, :order_id))
    return render json: { success: false, error: "Order not found" }, status: :not_found unless order

    buyer_account = SnfCore::VirtualAccount.find_by(user_id: order.user_id)
    seller_account = SnfCore::VirtualAccount.find_by(user_id: order.store.business.user_id)
    return render json: { success: false, error: "Virtual accounts not found" }, status: :not_found unless buyer_account && seller_account

    if buyer_account.balance < order.total_amount
      return render json: { success: false, error: "Insufficient balance" }, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      @record = SnfCore::VirtualAccountTransaction.new(
        from_account_id: buyer_account.id,
        to_account_id: seller_account.id,
        amount: order.total_amount,
        transaction_type: :transfer,
        status: :pending,
        reference_number: "ORDER-#{order.id}",
        description: "Payment for order ##{order.id}"
      )

      if @record.save
        buyer_account.update!(balance: buyer_account.balance - order.total_amount)
        seller_account.update!(balance: seller_account.balance + order.total_amount)
        @record.update!(status: :completed)

        render json: { success: true, data: @record }, status: :created
      else
        render json: { success: false, error: @record.errors.full_messages }, status: :unprocessable_entity
      end
    end
rescue ActiveRecord::RecordInvalid => e
  render json: { success: false, error: e.message }, status: :unprocessable_entity
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
      :order_id
    )
  end

  def update_order_status
    return unless @record && @record.status == "completed" && @record.reference_number.present?

    order_id = @record.reference_number.split("-").last
    order = SnfCore::Order.find_by(id: order_id)

    return unless order

    order.update(status: :confirmed)
  end
end
