class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :first_name,
             :middle_name,
             :last_name,
             :email,
             :phone_number,
             :date_of_birth,
             :nationality,
             :occupation,
             :source_of_funds,
             :kyc_status,
             :gender,
             :verified_at

  belongs_to :address
  belongs_to :verified_by, class_name: "SnfCore::User", optional: true
end
