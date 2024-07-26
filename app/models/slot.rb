class Slot < ApplicationRecord
  beloungs_to :service_center, dependent: :destroy
end
