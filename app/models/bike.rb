class Bike < ApplicationRecord
  belongs_to :service_center
  has_many :bookings
  has_one_attached :avatar

  validates :info, presence: true
  validates :regstration_num, presence: true

  before_save :set_default_rate

  state_machine :status, initial: :available do
    state :full_service
    state :wash_service
    state :engine_service
    state :on_rent
    state :not_available
    state :returned

    event :need_full_service do
      transition returned: :full_service
      transition wash_service: :full_service
      transition engine_service: :full_service
      transition not_available: :full_service
    end

    event :need_engine_service do
      transition returned: :engine_service
      transition wash_service: :engine_service
      transition not_available: :engine_service
      transition available: :engine_service
    end

    event :need_wash_service do
      transition [:returned, :not_available, :available] => :wash_service
    end

    event :rental do
      transition available: :on_rent
    end

    event :return do
      transition on_rent: :returned
    end

    event :avail do
      transition [:returned, :not_available, :full_service, :wash_service,
                  :engine_service] => :available
    end

    event :not_available do
      transition [:returned, :available, :full_service, :wash_service,
                  :engine_service] => :not_available
    end
  end

  private

  def set_default_rate
    self.rate ||= 0
  end
end
