class Rating < ApplicationRecord
  belongs_to :service_center
  belongs_to :client_user, class_name: 'ClientUser'

  validates :star, inclusion: { in: %w(1 2 3 4 5), message: "is not included in the list" }
  validates :comments, presence: true
end
