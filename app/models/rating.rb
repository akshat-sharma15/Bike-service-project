class Rating < ApplicationRecord
  belongs_to :service_center
  belongs_to :client_user, class_name: 'ClientUser'

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true
end
