class UserClient < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  self.table_name = 'users'
  # has_many :service_centers, foreign_key: :service_owner_id, dependent: :destroy, inverse_of: :service_owner

  default_scope { user_client }
  scope :user_client, -> { where(role: 0) }
end
