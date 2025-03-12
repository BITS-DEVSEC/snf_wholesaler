class VirtualAccountTransactionSerializer < ActiveModel::Serializer
  attributes :id, :from_account_id, :to_account_id, :amount, :transaction_type,
             :status, :reference_number, :description, :created_at, :updated_at

  belongs_to :from_account, class_name: "SnfCore::VirtualAccount"
  belongs_to :to_account, class_name: "SnfCore::VirtualAccount"
end
