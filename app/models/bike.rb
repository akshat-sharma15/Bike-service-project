class Bike < ApplicationRecord
  belongs_to :service_center
  has_many :bookings
  has_one_attached :avatar

  validates :info, presence: true
  validates :regstration_num, presence: true

  before_save :set_default_rate

  state_machine :status, initial: :avilable do
    state :full_service
    state :wash_service
    state :engine_service
    state :on_rent
    state :not_avilable
    state :returned

    event :need_full_service do
      transition returned: :full_service
      transition wash_service: :full_service
      transition engine_service: :full_service
      transition not_avilable: :full_service
    end

    event :need_engine_service do
      transition returned: :engine_service
      transition wash_service: :engine_service
      transition not_avilable: :engine_service
      transition avilable: :engine_service
    end

    event :need_wash_service do
      transition [:returned, :not_avilable, :avilable] => :wash_service
    end

    event :rental do
      transition avilable: :on_rent
    end

    event :return do
      transition on_rent: :returned
    end

    event :avail do
      transition [:returned, :not_avilable, :full_service, :wash_service, :engine_service] => :avilable
    end

    event :not_available do
      transition [:returned, :avilable, :full_service, :wash_service, :engine_service] => :not_avilable
    end

    after_transition to: :returned, do: :update_revenue
  end

  private

  def set_default_rate
    self.rate ||= 0
  end

  def update_revenue
    RevenueUpdate.new(self.service_center, self).update_rev_bike
  end
end
