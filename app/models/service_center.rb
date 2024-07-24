class ServiceCenter < ApplicationRecord
  belongs_to :service_owner, class_name: 'ServiceOwner', foreign_key: :service_owner_id,  inverse_of: :service_centers
  has_many :slots
end
