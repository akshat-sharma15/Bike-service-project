class RevenueUpdate
  attr_reader :service_center, :slot

  delegate :cost, to: :slot, prefix: true

  def initialize(service_center:, slot: nil)
    @service_center = service_center
    @slot = slot
  end

  def update_revenue
    revenue = service_center.revenues.find_by(date: Date.today)
    revenue ||= service_center.revenues.new(date: Date.today)
    set_revenue_amount(revenue: revenue, amount: slot_cost.to_f)
    revenue.save
  end

  def set_revenue_amount(revenue:, amount:)
    revenue.assign_attributes(revenue: revenue.revenue.to_f + amount)
  end
end
