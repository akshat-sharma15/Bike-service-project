class Booking < ApplicationRecord
  belongs_to :client_user, class_name: 'ClientUser',
                             inverse_of: :bookings
  belongs_to :bike
  belongs_to :service_center
  has_one_attached :document
  validate :valid_date,on: :create
  validates :booking_date, presence: true,on: :create
  validates :return_date, presence: true,on: :create

  scope :with_booking_date, ->(id) { where(booking_date: Date.today, status: :confirmed, bike_id: id) }

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
      transition active: :complete
    end

    event :reject do
      transition pending: :rejected
      transition confirmed: :rejected
    end
  end

  def valid_date
    if booking_date.present? && return_date.present?
      if booking_date < Date.today
        errors.add(:booking_date, "can't be in the past")
      end
      if return_date < booking_date
        errors.add(:return_date, 'must be after the booking date')
      end
    end
  end
end
