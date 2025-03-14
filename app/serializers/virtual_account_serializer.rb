class VirtualAccountSerializer < ActiveModel::Serializer
  attributes :id,
             :user_id,
             :branch_code,
             :product_scheme,
             :voucher_type,
             :balance,
             :interest_rate,
             :interest_type,
             :active,
             :cbs_account_number,
             :status

  belongs_to :user
end
