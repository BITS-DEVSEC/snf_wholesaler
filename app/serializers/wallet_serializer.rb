class WalletSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :wallet_number, :balance, :is_active,
             :created_at, :updated_at

  belongs_to :user
end
