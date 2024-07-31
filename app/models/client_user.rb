class ClientUser < ApplicationRecord
  self.table_name = 'users'
  has_many :slots,  inverse_of: :client_user
  has_many :bookings, inverse_of: :client_user
  has_many :rating

  default_scope { user_client }
  scope :user_client, -> { where(role: 0) }
end
