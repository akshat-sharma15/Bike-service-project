class Bike < ApplicationRecord
  belongs_to :service_center
  has_one_attached :avatar
end
