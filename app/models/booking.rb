class Booking < ApplicationRecord
  belongs_to :client_user, class_name: 'ClientUser',
                           inverse_of: :bookings
  belongs_to :bike
  belongs_to :service_center
  has_one_attached :document
  validate :valid_date, on: :create
  validates :booking_date, presence: true, on: :create
  validates :return_date, presence: true, on: :create

  scope :with_booking_date, lambda { |id|
                              where(booking_date: Date.today, status: :confirmed, bike_id: id)
                            }

  state_machine :status, initial: :pending do
    state :confirmed
    state :rejected
    state :active
    state :completed

    event :confirm do
      transition pending: :confirmed
    end

    event :activate do
      transition confirmed: :active
    end

    event :complete do
      transition active: :completed
    end

    event :reject do
      transition pending: :rejected
      transition confirmed: :rejected
    end

    after_transition to: :completed, do: :update_revenue
    before_transition to: :completed, do: :update_bike_state
  end

  private

  def update_revenue
    booking_cost_update
    RevenueUpdate.new(service_center: self.service_center, slot: self).update_revenue
  end

  def booking_cost_update
    if self.return_date == self.booking_date
      self.cost = self.bike.rate
    else
      self.return_date = Date.today 
      days = self.return_date - self.booking_date
      self.cost = self.bike.rate * days
    end
  end

  def update_bike_state
    if self.bike.status == 'on_rent'
      begin
        self.bike.return!
      rescue
        errors.add(:return_date, 'Booking not updated, check status of bike')
      end
    end
  end

  def valid_date
    return unless booking_date.present? && return_date.present?

    errors.add(:booking_date, "can't be in the past") if booking_date < Date.today
    return unless return_date < booking_date

    errors.add(:return_date, 'must be after the booking date')
  end
end
