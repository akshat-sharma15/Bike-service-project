class Slot < ApplicationRecord
  belongs_to :service_center, class_name: 'ServiceCenter'
  belongs_to :client_user, inverse_of: :slots

  validates :booking_date, presence: true
  validate :valid_date, on: :create
  validate :check_availability, on: :create

  state_machine :status, initial: :pending do
    state :pending
    state :confirmed
    state :on_service
    state :completed
    state :waiting
    state :rejected
    state :cancelled

    event :confirm do
      transition pending: :confirmed
      transition waiting: :confirmed
    end

    event :service do
      transition confirmed: :on_service
    end

    event :complete do
      transition on_service: :completed
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
      transition [:confirmed, :rejected, :on_service] => :pending
    end

    event :cancle do
      transition [:confirmed, :waiting, :pending] => :cancelled
    end

    after_transition to: :completed, do: :update_revenue
  end
  before_save :set_cost
  after_create :initial_state
  scope :with_booking_date, ->(date) { where(booking_date: date, status: :confirmed) }
  scope :working, ->(date) { where(booking_date: date, status: :on_service) }

  private

  def valid_date 
    errors.add(:booking_date, "can't be in the past") if Date.parse(self.booking_date) < Date.today
  end

  def set_cost
    case self.service_type.to_sym
    when :full_service
      self.cost = 1000.00
    when :engine_service
      self.cost = 500.00
    when :wash_service
      self.cost = 200.00
    else
      self.cost = -1.00
    end
  end

  def update_revenue
    RevenueUpdate.new(service_center: self.service_center, slot: self).update_revenue
  end

  def initial_state
    total = self.service_center.total_slots
    if status.to_sym == :pending && recent_booking?.present?
      reject!
    elsif status.to_sym  == :pending && Slot.with_booking_date(Date.parse(self.booking_date)).count >= total
      waits!
    elsif status.to_sym  == :pending && Slot.with_booking_date(Date.parse(self.booking_date)).count < total
      confirm!
    elsif status.to_sym  == :confirmed && (Slot.working(Date.parse(self.booking_date)).count < (total/2))
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
    start_date = date.prev_month(3)
    user = self.client_user
    user.slots.where(booking_date: start_date..date, service_center_id: self.service_center_id).count > 1
  end
end
