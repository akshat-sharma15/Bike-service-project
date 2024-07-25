class ServiceCenter < ApplicationRecord
  belongs_to :service_owner, class_name: 'ServiceOwner',
                             inverse_of: :service_centers
  has_many :slots
end
