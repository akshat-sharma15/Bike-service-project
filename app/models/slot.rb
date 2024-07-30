class Slot < ApplicationRecord
  belongs_to :service_center, class_name: 'ServiceCenter'
  belongs_to :client_user, inverse_of: :slots

  validates :booking_date, presence: true
  validate :valid_date
  validate :check_availability, on: :create

  state_machine :status, initial: :pending do
    state :pending
    state :confirmed
    state :on_service
    state :completed
    state :waiting
    state :rejected
    state :cancled
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
      transition [:confirmed, :waiting, :pending] => :cancled
    end

    after_transition to: :completed, do: :update_revenue
    # after_transition to: :rejected, do: :
  end
  before_save :set_cost
  before_save :initial_state
  scope :with_booking_date, ->(date) { where(booking_date: date, status: 'confirmed') }
  scope :working, ->(date) { where(booking_date: date, status: 'on_service') }

  private

  def valid_date
    unless Date.today <= Date.parse(self.booking_date)
      errors.add(:booking_date, "can't be in the past")
    end
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
    self.assign_attributes(
      cost: 
    )
  end

  def update_revenue
    RevenueUpdate.new(service_center: self.service_center, slot: self).update_revenue
  end

  def initial_state
    total = self.service_center.total_slots
    if status == 'pending' && recent_booking?.present?
      reject!
    elsif status == 'pending' && Slot.with_booking_date(Date.parse(self.booking_date)).count >= total
      waits!
    elsif status == 'pending' && Slot.with_booking_date(Date.parse(self.booking_date)).count < total
      confirm!
    elsif status == 'confirmed' && (Slot.working(Date.parse(self.booking_date)).count < (total/2))
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
    user.slots.where(booking_date: start_date..date, service_center_id: self.service_center_id)
  end
end
