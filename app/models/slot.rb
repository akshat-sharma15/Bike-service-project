class Slot < ApplicationRecord
  belongs_to :service_center, class_name: 'ServiceCenter'
  belongs_to :client_user, class_name: 'ClientUser', inverse_of: :slots

  validates :booking_date, presence: true
  validate :check_availability, on: :create

  state_machine :status, initial: :pending do
    state :pending
    state :confirmed
    state :on_service
    state :completed
    state :waiting
    state :rejected

    event :confirm do
      transition pending: :confirmed
      transition waiting: :confirmed
    end

    event :service do
      transition confirmed: :on_service
    end

    event :complete do
      transition on_service: :complete
    end

    event :reject do
      transition pending: :rejected
      transition on_service: :rejected
      transition confirmed: :rejected
      transition waiting: :rejected
    end

    event :waits do
      transition pending: :waiting, if: :recent_booking?
    end

    event :reset do
      transition [:confirmed, :rejected] => :pending
    end
  end

  after_save :initial_state
  scope :with_booking_date, ->(date) { where(booking_date: date, status: 'confirmed') }
  scope :working, ->(date) { where(booking_date: date, status: 'on_service') }


  private

  def initial_state
    total = self.service_center.total_slots
    if status == 'pending' && recent_booking?
      reject!
    elsif status == 'pending' && Slot.with_booking_date >= total
      waits!
    elsif status == 'pending' && Slot.with_booking_date < total
      confirm!
    elsif status == 'confirmed' && (Slot.working < (total/2))
      service!
    end
  end

  def check_availability
    count = Slot.with_booking_date(self.booking_date).count
    unless count < (self.service_center.total_slots || 0) + 3
      errors.add(:base, "No available slots for the selected date")
    end
  end

  def recent_booking?
    date = Date.parse(booking_date) rescue nil
    date >= 3.months.ago
  end
end
