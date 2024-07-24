class ServiceOwner < ApplicationRecord
  self.table_name = 'users'
  has_many :service_centers, foreign_key: :service_owner_id, dependent: :destroy, inverse_of: :service_owner

  # default_scope { owner }
  # scope :owner, -> { where(role: 2) }

end
